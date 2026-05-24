extends Control

@export_file("*.tscn") var restart_scene := "res://scenes/levels/level_01.tscn"

func _unhandled_input(event: InputEvent) -> void:
	if event == null:
		return

	if not event.is_pressed():
		return

	if restart_scene.strip_edges() == "":
		return

	if not ResourceLoader.exists(restart_scene):
		return

	get_tree().change_scene_to_file(restart_scene)
