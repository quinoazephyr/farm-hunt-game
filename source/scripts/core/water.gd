class_name Water
extends GeometryInstance3D

@export_node_path("RigidBody3D") var _character_node_path # to do multiple targets

var _positions : Array[Vector3] = []

@onready var _character = get_node(_character_node_path)

func _ready():
	for i in range(0, 20):
		_positions.push_back(_character.global_transform.origin)

func _process(delta):
	_positions.pop_front()
	_positions.push_back(_character.global_transform.origin)
	
	material_override.set_shader_parameter(
			"character_positions", \
			_positions)
	material_override.set_shader_parameter(
			"character_wave_height", \
			clamp((_positions[_positions.size() - 1] - _positions[0]).length(),
			0.0, 1.5))
