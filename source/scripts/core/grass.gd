@tool
class_name Grass
extends Node

@onready var _collision_viewport = $Collision
@onready var _simulation_viewport = $Simulation
@onready var _simulation_material = $Simulation/ColorRect.material
@onready var _grass_material = $Grass.material_override

func _ready() -> void:
	_grass_material.set_shader_parameter(
			"simulation_texture", _simulation_viewport.get_texture())
	_simulation_material.set_shader_parameter(
			"collision_texture", _collision_viewport.get_texture())
