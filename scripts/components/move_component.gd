extends Node
class_name MoveComponent

@export var max_speed := 320.0
@export var acceleration := 1800.0
@export var deceleration := 2200.0
@export var run_multiplier := 1.35

func compute_horizontal_velocity(current_velocity_x: float, input_axis: float, delta: float, is_on_floor_state: bool = true) -> float:
	if absf(input_axis) > 0.01:
		var target_speed := max_speed
		if is_on_floor_state:
			target_speed *= run_multiplier

		return move_toward(current_velocity_x, input_axis * target_speed, acceleration * delta)

	return move_toward(current_velocity_x, 0.0, deceleration * delta)
