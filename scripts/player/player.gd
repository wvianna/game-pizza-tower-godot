extends CharacterBody2D

@onready var move_component: MoveComponent = $MoveComponent
@onready var jump_component: JumpComponent = $JumpComponent
@onready var state_machine: StateMachineComponent = $StateMachineComponent
@onready var dash_component: DashComponent = $DashComponent
@onready var telemetry_component: TelemetryComponent = $TelemetryComponent
@onready var grab_throw_component: GrabThrowComponent = $GrabThrowComponent
@onready var parry_taunt_component: ParryTauntComponent = $ParryTauntComponent
@onready var grab_area: Area2D = $GrabArea
@onready var hold_anchor: Node2D = $HoldAnchor
@onready var visual_root: Node2D = $VisualRoot
@onready var pupil_visual: Polygon2D = $VisualRoot/Pupil
@onready var character_sprite: Sprite2D = $VisualRoot/CharacterSprite

var _facing_direction := 1
var _super_jump_charge := 0.0
var _super_jump_charging := false
var _body_slam_used_in_air := false
var _dash_was_active := false
var _was_on_floor := false
var _animation_time := 0.0
var _hit_stun_left := 0.0
var _taunt_anim_left := 0.0
var _hold_anchor_base_position := Vector2.ZERO
var _grab_area_base_position := Vector2.ZERO

func _ready() -> void:
	InputBootstrap.ensure_default_actions()
	add_to_group("player")
	telemetry_component.start_session()
	_hold_anchor_base_position = hold_anchor.position
	_grab_area_base_position = grab_area.position
	_load_character_texture()
	_was_on_floor = is_on_floor()

func _exit_tree() -> void:
	telemetry_component.export_report("session_end")

func _physics_process(delta: float) -> void:
	var input_axis := 0.0
	parry_taunt_component.update_component(delta)

	if _hit_stun_left <= 0.0:
		input_axis = Input.get_axis("move_left", "move_right")
		if absf(input_axis) > 0.01:
			_facing_direction = -1 if input_axis < 0.0 else 1
		_update_interaction_anchors(delta)
		_handle_grab_throw_input()
		_handle_taunt_parry_input()
	else:
		_hit_stun_left = maxf(_hit_stun_left - delta, 0.0)
		dash_component.reset_dash()
		_update_interaction_anchors(delta)
		velocity.x = move_toward(velocity.x, 0.0, move_component.deceleration * delta)

	if _hit_stun_left <= 0.0:
		dash_component.update_dash(delta, Input.is_action_pressed("dash"), input_axis, _facing_direction)

	var dash_is_active := dash_component.is_active()
	if dash_is_active and not _dash_was_active:
		_emit_audio("player_dash")
	_dash_was_active = dash_is_active

	if dash_is_active:
		var dash_direction := dash_component.get_direction(input_axis, _facing_direction)
		var dash_target_speed := dash_component.get_target_speed(move_component.max_speed) * float(dash_direction)
		velocity.x = move_toward(velocity.x, dash_target_speed, dash_component.get_dash_acceleration() * delta)
	elif _hit_stun_left <= 0.0:
		velocity.x = move_component.compute_horizontal_velocity(velocity.x, input_axis, delta, is_on_floor())
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_component.deceleration * delta)

	velocity.y += jump_component.get_gravity() * delta
	if _hit_stun_left <= 0.0 and Input.is_action_just_pressed("jump") and is_on_floor() and not Input.is_action_pressed("crouch"):
		velocity.y = jump_component.get_jump_velocity()
		_emit_audio("player_jump")

	if _hit_stun_left <= 0.0:
		_handle_super_jump(delta)
		_handle_body_slam()

	state_machine.update_state(self, dash_component.get_current_tier())

	var pre_collision_horizontal_speed := absf(velocity.x)
	var pre_collision_vertical_speed := velocity.y

	move_and_slide()
	_try_break_collided_blocks(pre_collision_horizontal_speed)

	if is_on_floor() and not _was_on_floor and pre_collision_vertical_speed > 260.0:
		_emit_audio("player_land")
	_was_on_floor = is_on_floor()

	telemetry_component.track_frame(delta, velocity, is_on_floor(), dash_component.get_current_tier())
	if Input.is_action_just_pressed("telemetry_export"):
		telemetry_component.export_report("manual_export")

	_update_visual_feedback(delta, input_axis)

func _handle_grab_throw_input() -> void:
	if not Input.is_action_just_pressed("grab_throw"):
		return

	if grab_throw_component.throw_carried(_facing_direction):
		_emit_audio("player_throw")
		return

	if grab_throw_component.try_grab_from(grab_area, self, hold_anchor):
		_emit_audio("collision_hit")

func _handle_taunt_parry_input() -> void:
	if not Input.is_action_just_pressed("taunt_parry"):
		return

	parry_taunt_component.activate_taunt()
	_taunt_anim_left = 0.22
	_emit_audio("player_taunt")
	for body in grab_area.get_overlapping_bodies():
		if parry_taunt_component.try_parry_object(body, _facing_direction):
			_emit_audio("collision_hit")
			break

func _handle_super_jump(delta: float) -> void:
	if not is_on_floor():
		_super_jump_charging = false
		_super_jump_charge = 0.0
		return

	if Input.is_action_pressed("crouch") and Input.is_action_pressed("jump"):
		_super_jump_charging = true
		_super_jump_charge += delta
		return

	if _super_jump_charging and Input.is_action_just_released("jump"):
		if jump_component.can_super_jump(_super_jump_charge):
			velocity.y = jump_component.get_super_jump_velocity()
			_emit_audio("player_jump")

	_super_jump_charging = false
	_super_jump_charge = 0.0

func _handle_body_slam() -> void:
	if is_on_floor():
		_body_slam_used_in_air = false
		return

	if _body_slam_used_in_air:
		return

	if Input.is_action_just_pressed("crouch"):
		velocity.y = jump_component.get_body_slam_velocity()
		_body_slam_used_in_air = true
		_emit_audio("player_dash")

func _try_break_collided_blocks(impact_speed: float) -> void:
	var dash_tier := dash_component.get_current_tier()
	for index in range(get_slide_collision_count()):
		var collision := get_slide_collision(index)
		if collision == null:
			continue

		var collider := collision.get_collider()
		if collider and collider.has_method("try_break"):
			var was_broken := bool(collider.call("try_break", impact_speed, dash_tier))
			if was_broken:
				_emit_audio("collision_break")

func _update_visual_feedback(delta: float, input_axis: float) -> void:
	var max_expected_speed := move_component.max_speed * dash_component.mach3_multiplier
	var speed_ratio := clampf(absf(velocity.x) / max_expected_speed, 0.0, 1.0)

	var stretch_x := 1.0 + speed_ratio * 0.22
	var stretch_y := 1.0 - speed_ratio * 0.14
	if not is_on_floor():
		stretch_x = 0.94
		stretch_y = 1.08

	var facing := -1.0 if _facing_direction < 0 else 1.0
	var target_scale := Vector2(stretch_x * facing, stretch_y)
	var blend := clampf(delta * 12.0, 0.0, 1.0)
	visual_root.scale = visual_root.scale.lerp(target_scale, blend)

	var target_rotation := clampf(velocity.x / 1300.0, -0.16, 0.16)
	visual_root.rotation = lerpf(visual_root.rotation, target_rotation, clampf(delta * 10.0, 0.0, 1.0))

	var eye_offset := clampf(input_axis * 1.8, -2.0, 2.0)
	pupil_visual.position.x = lerpf(pupil_visual.position.x, 10.0 + eye_offset, clampf(delta * 16.0, 0.0, 1.0))

	_update_sprite_animation(delta, input_axis, speed_ratio)

func _update_sprite_animation(delta: float, input_axis: float, speed_ratio: float) -> void:
	if character_sprite == null:
		return

	character_sprite.flip_h = _facing_direction < 0
	_taunt_anim_left = maxf(_taunt_anim_left - delta, 0.0)

	if _hit_stun_left > 0.0:
		character_sprite.frame_coords = Vector2i(2, 1)
		return

	if _taunt_anim_left > 0.0:
		character_sprite.frame_coords = Vector2i(3, 1)
		return

	if not is_on_floor():
		character_sprite.frame_coords = Vector2i(3, 0)
		return

	if dash_component.get_current_tier() >= 2:
		character_sprite.frame_coords = Vector2i(2, 0)
		return

	if grab_throw_component.has_carried_body():
		character_sprite.frame_coords = Vector2i(1, 0)
		return

	if absf(input_axis) > 0.01:
		_animation_time += delta * (7.0 + speed_ratio * 8.0)
		var run_frame := int(floor(_animation_time)) % 2
		character_sprite.frame_coords = Vector2i(run_frame, 1)
		return

	_animation_time = 0.0
	character_sprite.frame_coords = Vector2i(0, 0)

func apply_enemy_hit(from_position: Vector2) -> void:
	var knockback_direction := signf(global_position.x - from_position.x)
	if absf(knockback_direction) < 0.1:
		knockback_direction = -1.0 if _facing_direction > 0 else 1.0

	velocity.x = knockback_direction * 520.0
	velocity.y = -280.0
	_hit_stun_left = 0.24
	_emit_audio("player_hit")

func _emit_audio(event_name: String) -> void:
	get_tree().call_group("audio_director", "play_sfx", event_name)

func _update_interaction_anchors(delta: float) -> void:
	if hold_anchor == null or grab_area == null:
		return

	var target_hold_x := absf(_hold_anchor_base_position.x) * float(_facing_direction)
	var target_grab_x := absf(_grab_area_base_position.x) * float(_facing_direction)
	var blend := clampf(delta * 26.0, 0.0, 1.0)

	hold_anchor.position.x = lerpf(hold_anchor.position.x, target_hold_x, blend)
	grab_area.position.x = lerpf(grab_area.position.x, target_grab_x, blend)

func _load_character_texture() -> void:
	if character_sprite == null:
		return

	var texture := load("res://imagens/player_actions.png") as Texture2D
	if texture == null:
		return

	character_sprite.hframes = 4
	character_sprite.vframes = 2
	character_sprite.texture = texture

func get_dash_tier() -> int:
	return dash_component.get_current_tier()
