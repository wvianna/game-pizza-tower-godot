extends Area2D
class_name CollectibleTopping

signal collected(points: int)

@export var points := 100
@export var bob_height := 5.0
@export var bob_speed := 3.2

var _picked := false
var _base_position := Vector2.ZERO
var _elapsed := 0.0

func _ready() -> void:
	add_to_group("collectible_topping")
	_base_position = position
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if _picked:
		return

	_elapsed += delta * bob_speed
	position.y = _base_position.y + sin(_elapsed) * bob_height

func _on_body_entered(body: Node) -> void:
	if _picked:
		return

	if body == null:
		return

	if not body.is_in_group("player"):
		return

	_picked = true
	emit_signal("collected", points)
	queue_free()
