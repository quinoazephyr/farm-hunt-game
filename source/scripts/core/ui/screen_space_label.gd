class_name ScreenSpaceLabel
extends CanvasItem

@export_node_path("Camera3D") var _player_camera_path
@export_node_path("Label") var _label_path

@onready var _player_camera = get_node(_player_camera_path)
@onready var _label = get_node(_label_path)

func show_label(position : Vector3, text : String) -> void:
	_label.visible = !_player_camera.is_position_behind(position)
	_label.text = text
	self.position = _player_camera.unproject_position(position)

func hide_label() -> void:
	_label.hide()
