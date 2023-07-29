@tool
class_name Water
extends Node

@export var _skip_frames_count = 2

var _frame_counter = 0

@onready var _simulation_viewport = $Simulation
@onready var _simulation_material = $Simulation/ColorRect.material
@onready var _collision_viewport = $Collision
@onready var _water_plane = $WaterPlane

func _ready():
	_water_plane.material_override.set_shader_parameter(
		"simulation_texture", _simulation_viewport.get_texture())
	_simulation_material.set_shader_parameter(
		"col_tex", _collision_viewport.get_texture())

func _process(delta):
	_frame_counter += 1
	if _frame_counter % _skip_frames_count == 0:
		_simulation_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
