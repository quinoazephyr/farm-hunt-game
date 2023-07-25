@tool
class_name Grass
extends MultiMeshInstance3D

@onready var _collision_viewport = $"../GrassSim/Collision"
@onready var _simulation_viewport = $"../GrassSim/Simulation"
@onready var _simulation_material = $"../GrassSim/Simulation/ColorRect".material
@onready var _grass_material = material_override

func _ready() -> void:
	_grass_material.set_shader_parameter(
			"simulation_texture", _simulation_viewport.get_texture())
	_simulation_material.set_shader_parameter(
			"collision_texture", _collision_viewport.get_texture())
