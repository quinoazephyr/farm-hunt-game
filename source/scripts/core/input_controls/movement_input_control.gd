class_name MovementInputControl
extends InputControlBase

signal movement_changed(velocity)

func _unhandled_key_input(event : InputEvent) -> void:
	var input_axis = Input.get_vector(InputConstants.LEFT_ACTION_NAME, 
			InputConstants.RIGHT_ACTION_NAME, InputConstants.FORWARD_ACTION_NAME,
			InputConstants.BACK_ACTION_NAME)
	movement_changed.emit(input_axis)
