class_name PopulateButton
extends EditorProperty

# The main control for editing the property.
var property_control = Button.new()


func _init():
	# Add the control as a direct child of EditorProperty node.
	add_child(property_control)
	set_bottom_editor(property_control)
	# Make sure the control is able to retain the focus.
	add_focusable(property_control)
	# Setup the initial state and connect to the signal to track changes.
	property_control.text = "Populate"
	property_control.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_edited_object().populate_surface()

