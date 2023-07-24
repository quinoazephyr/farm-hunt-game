extends EditorInspectorPlugin

var generate_button_editor = \
		preload("res://addons/heightmap_generate_plugin/generate_button.gd")


func _can_handle(object):
	return object is GenerateHeightmapTool


func _parse_property(object: Object, type: Variant.Type, path: String, 
		hint_type: PropertyHint, hint_string: String, 
		usage_flags: int, wide: bool):
	# We handle properties of type integer.
	if path == "_button_placeholder":
		# Create an instance of the custom property editor and register
		# it to a specific property path.
		add_custom_control(generate_button_editor.new())
		# Inform the editor to remove the default property editor for
		# this property type.
		return true
	return false
