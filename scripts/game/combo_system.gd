extends Node
class_name ComboSystem

signal combo_changed(combo_count: int, multiplier: int, timer_left: float)
signal combo_broken(previous_combo: int)
signal score_changed(total_score: int, gained_score: int, source: String)

@export var combo_timeout := 3.4
@export var max_multiplier := 6

var combo_count := 0
var multiplier := 1
var total_score := 0
var timer_left := 0.0

func _process(delta: float) -> void:
	if combo_count <= 0:
		return

	timer_left = maxf(timer_left - delta, 0.0)
	emit_signal("combo_changed", combo_count, multiplier, timer_left)

	if timer_left <= 0.0:
		var previous := combo_count
		combo_count = 0
		multiplier = 1
		emit_signal("combo_broken", previous)
		emit_signal("combo_changed", combo_count, multiplier, timer_left)

func register_action(base_points: int, source: String = "action") -> int:
	if base_points <= 0:
		base_points = 1

	if combo_count <= 0 or timer_left <= 0.0:
		combo_count = 1
	else:
		combo_count += 1

	multiplier = min(max_multiplier, 1 + int(floor(float(combo_count - 1) / 2.0)))
	timer_left = combo_timeout

	var gained := base_points * multiplier
	total_score += gained

	emit_signal("score_changed", total_score, gained, source)
	emit_signal("combo_changed", combo_count, multiplier, timer_left)
	return gained

func force_break_combo() -> void:
	if combo_count <= 0:
		return

	var previous := combo_count
	combo_count = 0
	multiplier = 1
	timer_left = 0.0
	emit_signal("combo_broken", previous)
	emit_signal("combo_changed", combo_count, multiplier, timer_left)
