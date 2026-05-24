extends Node
class_name AudioDirector

const MIX_RATE := 44100

var _music_player: AudioStreamPlayer
var _audio_enabled := true

func _ready() -> void:
	add_to_group("audio_director")
	_audio_enabled = DisplayServer.get_name() != "headless"
	if not _audio_enabled:
		return

	_setup_music_player()
	_start_music()

func play_sfx(event_name: String) -> void:
	if not _audio_enabled:
		return

	match event_name:
		"player_jump":
			_play_tone(640.0, 0.08, 0.28, "square")
		"player_dash":
			_play_tone(160.0, 0.12, 0.33, "saw")
		"player_taunt":
			_play_tone(520.0, 0.1, 0.24, "triangle")
		"player_throw":
			_play_tone(300.0, 0.1, 0.28, "saw")
		"player_hit":
			_play_tone(120.0, 0.16, 0.34, "square")
		"player_land":
			_play_tone(90.0, 0.08, 0.26, "triangle")
		"enemy_alert":
			_play_tone(240.0, 0.07, 0.2, "square")
		"enemy_defeat":
			_play_tone(710.0, 0.12, 0.24, "triangle")
		"collect":
			_play_dual_tone(880.0, 1320.0, 0.09, 0.24)
		"collision_break":
			_play_tone(70.0, 0.12, 0.36, "noise")
		"collision_hit":
			_play_tone(180.0, 0.08, 0.28, "noise")
		"pillar_break":
			_play_dual_tone(190.0, 90.0, 0.26, 0.35, "square")
		"combo_break":
			_play_tone(160.0, 0.1, 0.2, "triangle")

func _setup_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.volume_db = -12.0
	_music_player.bus = "Master"
	_music_player.finished.connect(_on_music_finished)
	add_child(_music_player)

func _start_music() -> void:
	if _music_player == null:
		return

	_music_player.stream = _build_music_stream()
	_music_player.play()

func _on_music_finished() -> void:
	_start_music()

func _play_tone(frequency: float, duration: float, amplitude: float, waveform: String = "sine") -> void:
	var stream := _build_tone_stream(frequency, duration, amplitude, waveform)
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = -2.0
	player.bus = "Master"
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()

func _play_dual_tone(freq_a: float, freq_b: float, duration: float, amplitude: float, waveform: String = "sine") -> void:
	var stream := _build_dual_tone_stream(freq_a, freq_b, duration, amplitude, waveform)
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = -3.0
	player.bus = "Master"
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()

func _build_tone_stream(frequency: float, duration: float, amplitude: float, waveform: String) -> AudioStreamWAV:
	return _build_dual_tone_stream(frequency, 0.0, duration, amplitude, waveform)

func _build_dual_tone_stream(freq_a: float, freq_b: float, duration: float, amplitude: float, waveform: String = "sine") -> AudioStreamWAV:
	var sample_count: int = maxi(32, int(duration * MIX_RATE))
	var data: PackedByteArray = PackedByteArray()
	data.resize(sample_count * 2)

	for i in range(sample_count):
		var t: float = float(i) / float(MIX_RATE)
		var env_attack: float = minf(1.0, float(i) / maxf(1.0, float(sample_count) * 0.1))
		var env_release: float = minf(1.0, float(sample_count - i) / maxf(1.0, float(sample_count) * 0.12))
		var envelope: float = env_attack * env_release

		var sample: float = _sample_wave(freq_a, t, waveform)
		if freq_b > 0.0:
			sample = (sample + _sample_wave(freq_b, t, waveform)) * 0.5

		sample *= amplitude * envelope
		var pcm: int = int(clampf(sample, -1.0, 1.0) * 32767.0)
		var byte_index: int = i * 2
		data[byte_index] = pcm & 0xFF
		data[byte_index + 1] = (pcm >> 8) & 0xFF

	var stream: AudioStreamWAV = AudioStreamWAV.new()
	stream.mix_rate = MIX_RATE
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.data = data
	return stream

func _sample_wave(frequency: float, time_sec: float, waveform: String) -> float:
	if frequency <= 0.0:
		return 0.0

	var phase := fmod(time_sec * frequency, 1.0)
	match waveform:
		"square":
			return 1.0 if phase < 0.5 else -1.0
		"triangle":
			return 1.0 - 4.0 * absf(phase - 0.5)
		"saw":
			return (phase * 2.0) - 1.0
		"noise":
			return (randf() * 2.0) - 1.0
		_:
			return sin(TAU * phase)

func _build_music_stream() -> AudioStreamWAV:
	var motif_semitones: Array[int] = [0, 3, 7, 10, 7, 3, 5, 8, 12, 8, 5, 3, 2, 5, 9, 7]
	var phrase_shifts: Array[int] = [0, 2, 0, -2, 3, 0, -5, 0, 2, -3]
	var notes: Array[float] = []
	var root_frequency: float = 196.0

	# 10 frases x 16 notas = 160 notas por ciclo (10x mais notas que a versão anterior).
	for phrase_index in range(phrase_shifts.size()):
		var phrase_shift: int = phrase_shifts[phrase_index]
		for step_index in range(motif_semitones.size()):
			var semitone: int = motif_semitones[step_index] + phrase_shift
			if (phrase_index % 2) == 1 and (step_index % 4) == 2:
				semitone += 1
			var frequency: float = root_frequency * pow(2.0, float(semitone) / 12.0)
			notes.append(frequency)

	var bpm: float = 188.0
	var step_duration: float = (60.0 / bpm) * 0.25
	var total_duration: float = step_duration * float(notes.size())
	var sample_count: int = maxi(256, int(total_duration * MIX_RATE))
	var data: PackedByteArray = PackedByteArray()
	data.resize(sample_count * 2)
	var phrase_size: int = motif_semitones.size()
	var bar_duration: float = step_duration * 2.0

	for i in range(sample_count):
		var t: float = float(i) / float(MIX_RATE)
		var note_index: int = int(floor(t / step_duration)) % notes.size()
		var note_frequency: float = notes[note_index]
		var note_start: float = float(note_index) * step_duration
		var note_progress: float = (t - note_start) / step_duration
		var env_attack: float = minf(1.0, note_progress * 18.0)
		var env_release: float = minf(1.0, (1.0 - note_progress) * 8.0)
		var env: float = env_attack * env_release

		var accent: float = 1.2 if (note_index % 4) == 0 else 1.0
		var lead: float = _sample_wave(note_frequency, t, "saw") * 0.13 * env * accent

		var counter_index: int = (note_index + 3) % notes.size()
		var counter_freq: float = notes[counter_index] * 1.5
		var counter_gate: float = 0.72 if (note_index % 2) == 0 else 0.34
		var counter: float = _sample_wave(counter_freq, t, "square") * 0.05 * env * counter_gate

		var bass_index: int = int(floor(t / (step_duration * 2.0))) % phrase_size
		var bass_frequency: float = root_frequency * pow(2.0, float(motif_semitones[bass_index] - 12) / 12.0)
		var bass: float = _sample_wave(maxf(46.0, bass_frequency), t, "triangle") * 0.1

		var kick_phase: float = fmod(t, bar_duration) / bar_duration
		var kick_env: float = clampf(1.0 - kick_phase * 5.5, 0.0, 1.0)
		var kick: float = _sample_wave(52.0 + kick_env * 22.0, t, "sine") * 0.045 * kick_env

		var hat_phase: float = fmod(t, step_duration) / step_duration
		var hat_env: float = clampf(1.0 - hat_phase * 6.5, 0.0, 1.0)
		var hat: float = _sample_wave(8000.0, t, "noise") * 0.018 * hat_env

		var mixed: float = clampf(lead + counter + bass + kick + hat, -0.92, 0.92)

		var pcm: int = int(mixed * 32767.0)
		var byte_index: int = i * 2
		data[byte_index] = pcm & 0xFF
		data[byte_index + 1] = (pcm >> 8) & 0xFF

	var stream: AudioStreamWAV = AudioStreamWAV.new()
	stream.mix_rate = MIX_RATE
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.data = data
	return stream
