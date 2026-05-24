extends Node
class_name GrabThrowComponent

@export var throw_speed := 980.0
@export var throw_lift := 180.0

var _carried_body: Node = null

func has_carried_body() -> bool:
	return _carried_body != null and is_instance_valid(_carried_body)

func try_grab_from(grab_area: Area2D, carrier: Node2D, hold_anchor: Node2D) -> bool:
	if has_carried_body():
		return false

	for body in grab_area.get_overlapping_bodies():
		if body and body.has_method("pickup"):
			body.call("pickup", carrier, hold_anchor)
			_carried_body = body
			return true

	return false

func throw_carried(direction: int) -> bool:
	if not has_carried_body():
		return false

	if _carried_body.has_method("throw_object"):
		_carried_body.call("throw_object", direction, throw_speed, throw_lift)
		_carried_body = null
		return true

	if _carried_body.has_method("throw"):
		_carried_body.call("throw", direction, throw_speed, throw_lift)
		_carried_body = null
		return true

	return false

func drop_carried() -> void:
	if not has_carried_body():
		return

	if _carried_body.has_method("drop"):
		_carried_body.call("drop")

	_carried_body = null
