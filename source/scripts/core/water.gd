@tool
class_name Water
extends GeometryInstance3D

@export var _skip_frames_count = 2

var _frame_counter = 0

@onready var _simulation_viewport = $"../WaterSim/Simulation"
@onready var _collision_material = $"../WaterSim/Simulation/ColorRect".material
@onready var _collision_viewport = $"../WaterSim/Collision"

func _ready():
	material_override.set_shader_parameter(
		"simulation_texture", _simulation_viewport.get_texture())
	_collision_material.set_shader_parameter(
		"col_tex", _collision_viewport.get_texture())

func _process(delta):
	_frame_counter += 1
	if _frame_counter % _skip_frames_count == 0:
		_simulation_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
