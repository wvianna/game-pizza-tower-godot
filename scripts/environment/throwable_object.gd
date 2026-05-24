extends RigidBody2D
class_name ThrowableObject

var _is_carried := false
var _hold_anchor: Node2D = null

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

func parry_bounce(direction: int) -> void:
	_is_carried = false
	_hold_anchor = null
	freeze = false
	linear_velocity = Vector2(float(direction) * 1050.0, -220.0)

func _physics_process(_delta: float) -> void:
	if _is_carried and _hold_anchor != null:
		global_position = _hold_anchor.global_position
