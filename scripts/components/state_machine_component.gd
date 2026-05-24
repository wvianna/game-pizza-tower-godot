extends Node
class_name StateMachineComponent

enum PlayerState {
	IDLE,
	RUN,
	MACH1,
	MACH2,
	MACH3,
	AIR,
	CROUCH,
}

var current_state: PlayerState = PlayerState.IDLE

func update_state(player: CharacterBody2D, dash_tier: int = 0) -> void:
	if not player.is_on_floor():
		current_state = PlayerState.AIR
		return

	if dash_tier > 0:
		match dash_tier:
			1:
				current_state = PlayerState.MACH1
			2:
				current_state = PlayerState.MACH2
			_:
				current_state = PlayerState.MACH3
		return

	if Input.is_action_pressed("crouch"):
		current_state = PlayerState.CROUCH
		return

	if absf(player.velocity.x) > 5.0:
		current_state = PlayerState.RUN
		return

	current_state = PlayerState.IDLE
