extends RefCounted
class_name InputBootstrap

static var _initialized := false

static func ensure_default_actions() -> void:
	if _initialized:
		return

	_ensure_action("move_left", [_key(KEY_A), _key(KEY_LEFT), _joy_axis(JOY_AXIS_LEFT_X, -1.0), _dpad(JOY_BUTTON_DPAD_LEFT)])
	_ensure_action("move_right", [_key(KEY_D), _key(KEY_RIGHT), _joy_axis(JOY_AXIS_LEFT_X, 1.0), _dpad(JOY_BUTTON_DPAD_RIGHT)])
	_ensure_action("move_up", [_key(KEY_W), _key(KEY_UP), _joy_axis(JOY_AXIS_LEFT_Y, -1.0), _dpad(JOY_BUTTON_DPAD_UP)])
	_ensure_action("move_down", [_key(KEY_S), _key(KEY_DOWN), _joy_axis(JOY_AXIS_LEFT_Y, 1.0), _dpad(JOY_BUTTON_DPAD_DOWN)])
	_ensure_action("jump", [_key(KEY_SPACE), _key(KEY_Z), _joy_button(JOY_BUTTON_A)])
	_ensure_action("dash", [_key(KEY_SHIFT), _key(KEY_X), _joy_button(JOY_BUTTON_B), _joy_axis(JOY_AXIS_TRIGGER_RIGHT, 1.0)])
	_ensure_action("grab_throw", [_key(KEY_J), _key(KEY_C), _joy_button(JOY_BUTTON_X), _joy_button(JOY_BUTTON_RIGHT_SHOULDER)])
	_ensure_action("taunt_parry", [_key(KEY_K), _key(KEY_V), _joy_button(JOY_BUTTON_Y)])
	_ensure_action("crouch", [_key(KEY_CTRL), _key(KEY_S), _key(KEY_DOWN), _joy_axis(JOY_AXIS_TRIGGER_LEFT, 1.0)])
	_ensure_action("telemetry_export", [_key(KEY_F8)])

	_initialized = true

static func _ensure_action(action_name: StringName, events: Array[InputEvent]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	for event in events:
		if not InputMap.action_has_event(action_name, event):
			InputMap.action_add_event(action_name, event)

static func _key(keycode: Key) -> InputEvent:
	var event := InputEventKey.new()
	event.physical_keycode = keycode
	return event

static func _joy_button(button_index: JoyButton) -> InputEvent:
	var event := InputEventJoypadButton.new()
	event.button_index = button_index
	return event

static func _dpad(button_index: JoyButton) -> InputEvent:
	return _joy_button(button_index)

static func _joy_axis(axis: JoyAxis, axis_value: float) -> InputEvent:
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = axis_value
	return event
