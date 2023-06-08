class_name ActionInputControl
extends InputControlBase

signal accept_requested
signal cancel_requested
signal action_x_requested
signal action_y_requested

signal ui_accept_requested

func _unhandled_key_input(event : InputEvent) -> void:
	if Input.is_action_just_pressed(InputConstants.ACCEPT_ACTION_NAME):
		accept_requested.emit()
		_viewport.set_input_as_handled()
	elif Input.is_action_just_pressed(InputConstants.ACTION_X_ACTION_NAME):
		action_x_requested.emit()
		_viewport.set_input_as_handled()
	elif Input.is_action_just_pressed(InputConstants.ACTION_Y_ACTION_NAME):
		action_y_requested.emit()
		_viewport.set_input_as_handled()
	elif Input.is_action_just_pressed(InputConstants.CANCEL_ACTION_NAME):
		cancel_requested.emit()
		_viewport.set_input_as_handled()
	elif Input.is_action_just_pressed(InputConstants.UI_ACCEPT_ACTION_NAME):
		ui_accept_requested.emit()
		_viewport.set_input_as_handled()
