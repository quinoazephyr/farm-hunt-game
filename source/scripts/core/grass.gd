class_name Grass
extends MultiMeshInstance3D

@export_node_path("RigidBody3D") var _character_node_path # to do multiple targets

@onready var _character = get_node(_character_node_path)

func _process(delta):
	material_override.set_shader_parameter(
		"character_position", _character.global_transform.origin)
