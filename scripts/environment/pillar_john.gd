extends Area2D
class_name PillarJohn

signal pillar_destroyed

@export var required_dash_tier := 1

var _destroyed := false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var intact_visual: CanvasItem = $IntactVisual
@onready var broken_visual: CanvasItem = $BrokenVisual

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	broken_visual.visible = false

func _on_body_entered(body: Node) -> void:
	if _destroyed:
		return

	if body == null:
		return

	if not body.is_in_group("player"):
		return

	var dash_tier := 0
	if body.has_method("get_dash_tier"):
		dash_tier = int(body.call("get_dash_tier"))

	if dash_tier < required_dash_tier:
		return

	_destroyed = true
	intact_visual.visible = false
	broken_visual.visible = true
	collision_shape.set_deferred("disabled", true)
	monitoring = false
	emit_signal("pillar_destroyed")
