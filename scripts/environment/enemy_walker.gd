extends CharacterBody2D
class_name EnemyWalker

signal defeated(points: int, reason: String)

@export var patrol_distance := 220.0
@export var walk_speed := 170.0
@export var gravity := 1800.0
@export var defeat_points := 220
@export var throw_break_speed := 620.0

@onready var hit_area: Area2D = $HitArea
@onready var sprite: Sprite2D = $VisualRoot/Sprite
@onready var body_collision: CollisionShape2D = $CollisionShape2D

var _origin_x := 0.0
var _direction := 1
var _defeated := false
var _is_carried := false
var _hold_anchor: Node2D = null
var _launch_timer := 0.0

func _ready() -> void:
	add_to_group("active_enemy")
	_origin_x = global_position.x
	_load_enemy_texture()
	hit_area.body_entered.connect(_on_hit_area_body_entered)

func _physics_process(delta: float) -> void:
	if _defeated:
		return

	if _is_carried:
		if _hold_anchor != null:
			global_position = _hold_anchor.global_position
		return

	velocity.y += gravity * delta
	velocity.x = float(_direction) * walk_speed

	if _launch_timer > 0.0:
		_launch_timer = maxf(_launch_timer - delta, 0.0)

	move_and_slide()

	if _launch_timer > 0.0 and (is_on_wall() or is_on_floor()) and absf(velocity.x) >= throw_break_speed * 0.35:
		_defeat("throw")
		return

	if is_on_wall():
		_direction *= -1

	if absf(global_position.x - _origin_x) > patrol_distance:
		_direction = -1 if global_position.x > _origin_x else 1

	sprite.flip_h = _direction < 0

func pickup(_carrier: Node2D, hold_anchor: Node2D) -> void:
	if _defeated:
		return

	_is_carried = true
	_hold_anchor = hold_anchor
	velocity = Vector2.ZERO
	body_collision.disabled = true
	hit_area.monitoring = false
	hit_area.monitorable = false

func drop() -> void:
	_is_carried = false
	_hold_anchor = null
	body_collision.disabled = false
	hit_area.monitoring = true
	hit_area.monitorable = true

func throw_object(direction: int, speed: float, upward_speed: float) -> void:
	drop()
	velocity = Vector2(float(direction) * speed, -upward_speed)
	_launch_timer = 0.35

func parry_bounce(direction: int) -> void:
	drop()
	velocity = Vector2(float(direction) * 1080.0, -260.0)
	_launch_timer = 0.35

func _on_hit_area_body_entered(body: Node) -> void:
	if _defeated:
		return

	if body == null or not body.is_in_group("player"):
		return

	var dash_tier := 0
	if body.has_method("get_dash_tier"):
		dash_tier = int(body.call("get_dash_tier"))

	if dash_tier > 0:
		_defeat("dash")
		return

	if body.has_method("apply_enemy_hit"):
		body.call("apply_enemy_hit", global_position)

	get_tree().call_group("audio_director", "play_sfx", "enemy_alert")

func _defeat(reason: String) -> void:
	if _defeated:
		return

	_defeated = true
	emit_signal("defeated", defeat_points, reason)
	get_tree().call_group("audio_director", "play_sfx", "enemy_defeat")
	queue_free()

func _load_enemy_texture() -> void:
	if sprite == null:
		return

	var image := Image.new()
	if image.load("res://imagens/personagens2.webp") != OK:
		if image.load("res://imagens/personagens.png") != OK:
			return

	sprite.texture = ImageTexture.create_from_image(image)
