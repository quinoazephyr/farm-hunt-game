class_name GrassCamera
extends Camera3D

@export_node_path("RigidBody3D") var _player_node_path

var _stepped_position : Vector3
var _previous_position : Vector3

@onready var _normalmap_viewport = $"../../NormalmapViewport"
@onready var _blurred_normalmap_viewport = $"../../BlurPass2"
@onready var _process_grass_viewport = $"../../ProcessGrassViewport"
@onready var _grass_viewport = $".."

@onready var _viewport_resolution = _grass_viewport.size.x
@onready var _process_grass_material = \
		$"../../ProcessGrassViewport/ProcessGrass".material
@onready var _normalmap_material = $"../../NormalmapViewport/ProcessNormal".material
@onready var _grass_material = $"../../../Grass".material_override
@onready var _player = get_node(_player_node_path)
@onready var _player_start_position = _player.global_transform.origin
@onready var _pixel_step = size / float(_viewport_resolution)

func _ready():
	_process_grass_material.set_shader_parameter(
			"grass_input", _grass_viewport.get_texture())
	_normalmap_material.set_shader_parameter(
			"interact_map", _process_grass_viewport.get_texture())
	_grass_material.set_shader_parameter(
			"interact_map", _process_grass_viewport.get_texture())
	_grass_material.set_shader_parameter(
			"normal_map", _blurred_normalmap_viewport.get_texture())

func _process(delta : float) -> void:
	var position_offset = _player.global_position - _player_start_position
	position_offset = position_offset.snapped(Vector3.ONE * _pixel_step)
	var new_position = _player_start_position + position_offset
	new_position.y = 0.0
	
	_stepped_position = new_position
	var change_vector = _previous_position - _stepped_position
	_previous_position = _stepped_position
	
	global_position = Vector3(_player.global_position.x, global_position.y, \
			_player.global_position.z)
	
	_process_grass_material.set_shader_parameter("movement_vector", change_vector)
	_process_grass_material.set_shader_parameter("camera_position", global_position)
	_grass_material.set_shader_parameter("camera_position", global_position)
