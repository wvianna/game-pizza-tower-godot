extends StaticBody2D
class_name DestructibleBlock

@export var break_speed := 700.0
@export var min_dash_tier := 1

var _broken := false

func try_break(impact_speed: float, dash_tier: int) -> bool:
	if _broken:
		return false

	if impact_speed < break_speed:
		return false

	if dash_tier < min_dash_tier:
		return false

	_broken = true
	get_tree().call_group("audio_director", "play_sfx", "collision_break")
	queue_free()
	return true
