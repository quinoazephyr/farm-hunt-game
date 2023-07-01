class_name MovementInputControl
extends InputControlBase

func get_input_axis() -> Vector2:
	return Input.get_vector(InputConstants.LEFT_ACTION_NAME, 
			InputConstants.RIGHT_ACTION_NAME, InputConstants.FORWARD_ACTION_NAME,
			InputConstants.BACK_ACTION_NAME)
