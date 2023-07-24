@tool
class_name GenerateHeightmapTool
extends Node

@export_dir var _path
@export var _name : String
@export var _button_placeholder : bool

func generate_heightmap():
	_generate_heightmap("%s/%s.png" % [_path, _name])

func _generate_heightmap(path : String):
	var img = get_viewport().get_texture().get_image()
	img.save_png(path)
	print("Heightmap was generated in \"%s\" REMOVE FOCUS FROM THE EDITOR" % path)
