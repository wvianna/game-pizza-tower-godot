extends RigidBody2D
class_name ThrowableObject

var _is_carried := false
var _hold_anchor: Node2D = null
var _impact_cooldown := 0.0

func pickup(_carrier: Node2D, hold_anchor: Node2D) -> void:
	_is_carried = true
	_hold_anchor = hold_anchor
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	global_position = _hold_anchor.global_position

func drop() -> void:
	_is_carried = false
	_hold_anchor = null
	freeze = false

func throw_object(direction: int, speed: float, upward_speed: float) -> void:
	drop()
	linear_velocity = Vector2(float(direction) * speed, -upward_speed)
	get_tree().call_group("audio_director", "play_sfx", "player_throw")

func parry_bounce(direction: int) -> void:
	_is_carried = false
	_hold_anchor = null
	freeze = false
	linear_velocity = Vector2(float(direction) * 1050.0, -220.0)
	get_tree().call_group("audio_director", "play_sfx", "collision_hit")

func _physics_process(delta: float) -> void:
	if _is_carried and _hold_anchor != null:
		global_position = _hold_anchor.global_position
		return

	if _impact_cooldown > 0.0:
		_impact_cooldown = maxf(_impact_cooldown - delta, 0.0)

	if _impact_cooldown > 0.0:
		return

	if linear_velocity.length() < 220.0:
		return

	if get_colliding_bodies().is_empty():
		return

	_impact_cooldown = 0.15
	get_tree().call_group("audio_director", "play_sfx", "collision_hit")
