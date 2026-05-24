extends Node
class_name TelemetryComponent

var _session_started_unix := 0
var _max_horizontal_speed := 0.0
var _max_total_speed := 0.0
var _time_in_air := 0.0
var _time_on_ground := 0.0
var _dash_tier_time := {
	0: 0.0,
	1: 0.0,
	2: 0.0,
	3: 0.0,
}

func start_session() -> void:
	_session_started_unix = Time.get_unix_time_from_system()
	_max_horizontal_speed = 0.0
	_max_total_speed = 0.0
	_time_in_air = 0.0
	_time_on_ground = 0.0
	_dash_tier_time[0] = 0.0
	_dash_tier_time[1] = 0.0
	_dash_tier_time[2] = 0.0
	_dash_tier_time[3] = 0.0

func track_frame(delta: float, velocity: Vector2, on_floor: bool, dash_tier: int) -> void:
	_max_horizontal_speed = maxf(_max_horizontal_speed, absf(velocity.x))
	_max_total_speed = maxf(_max_total_speed, velocity.length())

	if on_floor:
		_time_on_ground += delta
	else:
		_time_in_air += delta

	var safe_tier := clampi(dash_tier, 0, 3)
	_dash_tier_time[safe_tier] += delta

func export_report(reason: String = "manual") -> String:
	var report := {
		"reason": reason,
		"started_at_unix": _session_started_unix,
		"exported_at_unix": Time.get_unix_time_from_system(),
		"max_horizontal_speed": _max_horizontal_speed,
		"max_total_speed": _max_total_speed,
		"time_in_air": _time_in_air,
		"time_on_ground": _time_on_ground,
		"dash_tier_time": _dash_tier_time,
	}

	var telemetry_dir := "user://telemetry"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(telemetry_dir))

	var report_name := "run_%s_%s.json" % [str(_session_started_unix), str(Time.get_unix_time_from_system())]
	var report_path := "%s/%s" % [telemetry_dir, report_name]
	var file := FileAccess.open(report_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(report, "\t"))
		file.close()

	return report_path
