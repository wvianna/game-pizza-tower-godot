extends Node2D
class_name LevelController

@export_file("*.tscn") var next_level_scene := ""
@export var escape_duration := 30.0
@export var collectible_bonus_seconds := 1.25
@export_file("*.tscn") var fallback_scene := "res://scenes/game/victory_screen.tscn"

var _phase := "explore"
var _time_left := 0.0
var _collected := 0
var _total_collectibles := 0
var _score := 0
var _combo_count := 0
var _combo_multiplier := 1
var _combo_timer_left := 0.0

var _combo_system: Node = null
var _audio_director: Node = null

@onready var player: Node = get_node_or_null("Player")
@onready var pillar: Node = get_node_or_null("PillarJohn")
@onready var exit_area: Area2D = get_node_or_null("ExitArea")
@onready var shortcut_block: Node = get_node_or_null("EscapeShortcutBlock")
@onready var hud_layer: CanvasLayer = get_node_or_null("HudLayer")
@onready var objective_label: Label = get_node_or_null("HudLayer/ObjectiveLabel")
@onready var timer_label: Label = get_node_or_null("HudLayer/TimerLabel")
@onready var collect_label: Label = get_node_or_null("HudLayer/CollectLabel")
@onready var combo_label: Label = get_node_or_null("HudLayer/ComboLabel")

func _ready() -> void:
	_ensure_runtime_nodes()
	_ensure_controls_overlay()
	_ensure_combo_label()

	if pillar != null and pillar.has_signal("pillar_destroyed"):
		pillar.connect("pillar_destroyed", Callable(self, "_on_pillar_destroyed"))

	if exit_area != null:
		exit_area.body_entered.connect(_on_exit_area_body_entered)

	_connect_collectibles()
	_connect_player_score_sources()
	_connect_existing_enemies()

	if not get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.connect(_on_tree_node_added)

	_update_hud_labels()
	_set_explore_text()

func _process(delta: float) -> void:
	if _phase == "escape":
		_time_left -= delta
		if _time_left <= 0.0:
			_time_left = 0.0
			_update_hud_labels()
			_on_escape_failed()
			return

	_update_hud_labels()


func _ensure_runtime_nodes() -> void:
	_combo_system = get_node_or_null("ComboSystem")
	if _combo_system == null:
		var combo_script := load("res://scripts/game/combo_system.gd")
		if combo_script != null:
			_combo_system = combo_script.new()
			_combo_system.name = "ComboSystem"
			add_child(_combo_system)

	if _combo_system != null:
		if not _combo_system.is_connected("score_changed", Callable(self, "_on_combo_score_changed")):
			_combo_system.connect("score_changed", Callable(self, "_on_combo_score_changed"))
		if not _combo_system.is_connected("combo_changed", Callable(self, "_on_combo_changed")):
			_combo_system.connect("combo_changed", Callable(self, "_on_combo_changed"))
		if not _combo_system.is_connected("combo_broken", Callable(self, "_on_combo_broken")):
			_combo_system.connect("combo_broken", Callable(self, "_on_combo_broken"))

	_audio_director = get_node_or_null("AudioDirector")
	if _audio_director == null:
		var audio_script := load("res://scripts/audio/audio_director.gd")
		if audio_script != null:
			_audio_director = audio_script.new()
			_audio_director.name = "AudioDirector"
			add_child(_audio_director)

func _ensure_controls_overlay() -> void:
	if hud_layer == null:
		return

	if hud_layer.get_node_or_null("ControlsPanel") != null:
		return

	var panel := Panel.new()
	panel.name = "ControlsPanel"
	panel.anchor_left = 1.0
	panel.anchor_top = 0.0
	panel.anchor_right = 1.0
	panel.anchor_bottom = 0.0
	panel.offset_left = -372.0
	panel.offset_top = 14.0
	panel.offset_right = -14.0
	panel.offset_bottom = 220.0

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.05, 0.05, 0.09, 0.82)
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color = Color(1.0, 0.72, 0.35, 1.0)
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12
	panel.add_theme_stylebox_override("panel", panel_style)
	hud_layer.add_child(panel)

	var label := Label.new()
	label.name = "ControlsLabel"
	label.offset_left = 12.0
	label.offset_top = 10.0
	label.offset_right = 346.0
	label.offset_bottom = 194.0
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.add_theme_color_override("font_color", Color(0.96, 0.94, 0.88, 1.0))
	label.add_theme_font_size_override("font_size", 13)
	label.text = "CONTROLES\nA / D ou <- ->  mover\nEspaco  pular\nShift  dash\nCtrl  agachar\nJ  agarrar / arremessar\nK  taunt / parry\n\nDica: mantenha o combo ativo derrotando inimigos e coletando sem parar."
	panel.add_child(label)

func _ensure_combo_label() -> void:
	if hud_layer == null:
		return

	if combo_label != null:
		return

	combo_label = Label.new()
	combo_label.name = "ComboLabel"
	combo_label.offset_left = 250.0
	combo_label.offset_top = 52.0
	combo_label.offset_right = 540.0
	combo_label.offset_bottom = 78.0
	combo_label.add_theme_color_override("font_color", Color(1.0, 0.87, 0.45, 1.0))
	combo_label.add_theme_font_size_override("font_size", 14)
	hud_layer.add_child(combo_label)

func _connect_collectibles() -> void:
	_total_collectibles = 0
	for collectible in get_tree().get_nodes_in_group("collectible_topping"):
		if not is_ancestor_of(collectible):
			continue

		_total_collectibles += 1
		if collectible.has_signal("collected"):
			collectible.connect("collected", Callable(self, "_on_collectible_collected"))

func _connect_player_score_sources() -> void:
	if player == null:
		return

	var parry_component := player.get_node_or_null("ParryTauntComponent")
	if parry_component == null:
		return

	if not parry_component.is_connected("score_event", Callable(self, "_on_player_score_event")):
		parry_component.connect("score_event", Callable(self, "_on_player_score_event"))

func _connect_existing_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("active_enemy"):
		if not is_ancestor_of(enemy):
			continue
		_connect_enemy(enemy)

func _on_tree_node_added(node: Node) -> void:
	if node == null:
		return

	if not node.is_in_group("active_enemy"):
		return

	if not is_ancestor_of(node):
		return

	_connect_enemy(node)

func _connect_enemy(enemy: Node) -> void:
	if enemy == null:
		return

	if not enemy.has_signal("defeated"):
		return

	if enemy.is_connected("defeated", Callable(self, "_on_enemy_defeated")):
		return

	enemy.connect("defeated", Callable(self, "_on_enemy_defeated"))

func _on_collectible_collected(points: int) -> void:
	_collected += 1
	_register_action(points, "collectible")
	_emit_audio("collect")
	_update_hud_labels()

func _on_pillar_destroyed() -> void:
	if _phase == "escape":
		return

	_phase = "escape"
	_time_left = escape_duration + float(_collected) * collectible_bonus_seconds

	if shortcut_block != null and is_instance_valid(shortcut_block):
		shortcut_block.queue_free()

	_register_action(300, "pillar")
	_emit_audio("pillar_break")
	_set_escape_text()
	_update_hud_labels()

func _on_enemy_defeated(points: int, reason: String) -> void:
	_register_action(points, "enemy_%s" % reason)
	_update_hud_labels()

func _on_player_score_event(points: int, reason: String) -> void:
	_register_action(points, reason)
	_update_hud_labels()

func _register_action(points: int, source: String) -> void:
	if _combo_system != null:
		_combo_system.register_action(points, source)
		return

	_score += points

func _on_combo_score_changed(total_score: int, _gained_score: int, _source: String) -> void:
	_score = total_score
	_update_hud_labels()

func _on_combo_changed(combo_count: int, multiplier: int, timer_left: float) -> void:
	_combo_count = combo_count
	_combo_multiplier = multiplier
	_combo_timer_left = timer_left
	_update_hud_labels()

func _on_combo_broken(previous_combo: int) -> void:
	if previous_combo >= 3:
		_emit_audio("combo_break")
	_update_hud_labels()

func _on_exit_area_body_entered(body: Node) -> void:
	if _phase != "escape":
		return

	if body == null:
		return

	if not body.is_in_group("player"):
		return

	_complete_level()

func _complete_level() -> void:
	if objective_label:
		objective_label.text = "Fase concluida!"

	var target_scene := fallback_scene
	if next_level_scene.strip_edges() != "" and ResourceLoader.exists(next_level_scene):
		target_scene = next_level_scene

	call_deferred("_deferred_change_scene", target_scene)

func _on_escape_failed() -> void:
	if objective_label:
		objective_label.text = "Tempo esgotado! Reiniciando..."

	if _combo_system != null:
		_combo_system.force_break_combo()

	call_deferred("_deferred_reload_scene")

func _deferred_change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func _deferred_reload_scene() -> void:
	get_tree().reload_current_scene()

func _set_explore_text() -> void:
	if objective_label:
		objective_label.text = "Objetivo: destrua o Pillar John"

func _set_escape_text() -> void:
	if objective_label:
		objective_label.text = "PIZZA TIME! Volte para a entrada!"

func _update_hud_labels() -> void:
	if timer_label:
		if _phase == "escape":
			timer_label.text = "Tempo: %.1f" % _time_left
		else:
			timer_label.text = "Tempo: --"

	if collect_label:
		collect_label.text = "Coletaveis: %d/%d | Score: %d" % [_collected, _total_collectibles, _score]

	if combo_label:
		if _combo_count > 0:
			combo_label.text = "Combo x%d  |  Hits: %d  |  %.1fs" % [_combo_multiplier, _combo_count, _combo_timer_left]
		else:
			combo_label.text = "Combo: --"

func _emit_audio(event_name: String) -> void:
	get_tree().call_group("audio_director", "play_sfx", event_name)
