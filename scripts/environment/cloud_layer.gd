extends Node2D
class_name CloudLayer

@export var base_speed := 12.0
@export var wrap_start_x := -260.0
@export var wrap_end_x := 2300.0

func _process(delta: float) -> void:
	for child in get_children():
		if child is not Node2D:
			continue

		var node := child as Node2D
		var speed_scale := 0.8 + float(node.get_index()) * 0.22
		node.position.x += base_speed * speed_scale * delta

		if node.position.x > wrap_end_x:
			node.position.x = wrap_start_x
