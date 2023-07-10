class_name Water
extends GeometryInstance3D

@export var _skip_frames_count = 2

var _frame_counter = 0

@onready var simulation_viewport = $"../Simulation"

func _process(delta):
	_frame_counter += 1
	if _frame_counter % _skip_frames_count == 0:
		simulation_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
