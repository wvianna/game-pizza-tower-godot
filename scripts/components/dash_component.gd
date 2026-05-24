extends Node
class_name DashComponent

@export var mach2_time := 0.35
@export var mach3_time := 0.90

@export var mach1_multiplier := 1.25
@export var mach2_multiplier := 1.85
@export var mach3_multiplier := 2.45

@export var dash_acceleration := 3200.0

var _is_active := false
var _hold_time := 0.0
var _current_tier := 0
var _dash_direction := 1

func update_dash(delta: float, dash_pressed: bool, input_axis: float, facing_direction: int) -> void:
	if dash_pressed:
		_is_active = true
		_hold_time += delta
		_update_tier()

		if absf(input_axis) > 0.01:
			_dash_direction = _sign_non_zero(input_axis)
		elif _dash_direction == 0:
			_dash_direction = facing_direction
		return

	reset_dash()

func reset_dash() -> void:
	_is_active = false
	_hold_time = 0.0
	_current_tier = 0

func is_active() -> bool:
	return _is_active

func get_current_tier() -> int:
	return _current_tier

func get_direction(input_axis: float, facing_direction: int) -> int:
	if absf(input_axis) > 0.01:
		return _sign_non_zero(input_axis)

	if _dash_direction == 0:
		return facing_direction

	return _dash_direction

func get_target_speed(base_speed: float) -> float:
	if not _is_active or _current_tier <= 0:
		return base_speed

	if _current_tier == 1:
		return base_speed * mach1_multiplier
	if _current_tier == 2:
		return base_speed * mach2_multiplier
	return base_speed * mach3_multiplier

func get_dash_acceleration() -> float:
	return dash_acceleration

func _update_tier() -> void:
	if _hold_time >= mach3_time:
		_current_tier = 3
		return

	if _hold_time >= mach2_time:
		_current_tier = 2
		return

	_current_tier = 1

func _sign_non_zero(value: float) -> int:
	if value < 0.0:
		return -1
	return 1
