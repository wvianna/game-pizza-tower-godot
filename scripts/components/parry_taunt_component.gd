extends Node
class_name ParryTauntComponent

signal score_event(points: int, reason: String)

@export var parry_window := 0.18
@export var taunt_points := 100
@export var parry_points := 150

var _parry_time_left := 0.0

func update_component(delta: float) -> void:
	if _parry_time_left > 0.0:
		_parry_time_left = maxf(_parry_time_left - delta, 0.0)

func activate_taunt() -> void:
	_parry_time_left = parry_window
	emit_signal("score_event", taunt_points, "taunt")

func is_parry_active() -> bool:
	return _parry_time_left > 0.0

func try_parry_object(target: Object, direction: int) -> bool:
	if not is_parry_active():
		return false

	if target == null:
		return false

	if target.has_method("parry_bounce"):
		target.call("parry_bounce", direction)
		emit_signal("score_event", parry_points, "parry")
		return true

	return false
