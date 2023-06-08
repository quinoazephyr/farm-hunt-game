class_name CameraPlayer
extends Node3D

const _INPUT_MOUSE_ROTATE_ACTION_NAME = "camera_rotate_mouse"
const _ROTATION_LIMIT_Y_MIN = -45.0
const _ROTATION_LIMIT_Y_MAX = 89.0
const _LOOK_SMOOTH_WEIGHT = 1.0
const _MOUSE_SENSITIVITY = 0.3

@export var _invert_x : bool
@export var _invert_y : bool

var camera_right:
	get:
		return _camera.global_transform.basis.x

var camera_forward:
	get:
		var cam_fwd = _camera.global_transform.basis.z
		return cam_fwd.slide(Vector3.UP).normalized() # make cam_fwd horizontal

var _target : Node3D = null
var _target_rotation_x_deg : float = 0.0
var _target_rotation_y_deg : float = 0.0
var _current_camera_rotation_x_rad : float = 0.0
var _current_camera_rotation_y_rad: float = 0.0

@onready var _camera : Camera3D = $CameraPlayer
@onready var _viewport = get_viewport()
@onready var _last_mouse_pos : Vector2 = _viewport.get_mouse_position()
@onready var _input_axis_coefficient_x = -1.0 if _invert_x else 1.0
@onready var _input_axis_coefficient_y = -1.0 if _invert_y else 1.0

func _process(delta) -> void:
	if _target:
		global_position = _target.global_position

func _unhandled_input(event) -> void:
	var mouse_pos = _viewport.get_mouse_position()
	var mouse_pos_offset = Vector2(mouse_pos.x - _last_mouse_pos.x,
			_last_mouse_pos.y - mouse_pos.y)
	_last_mouse_pos = mouse_pos
	
	var is_rotate = Input.is_action_pressed(_INPUT_MOUSE_ROTATE_ACTION_NAME)
	if is_rotate:
		_target_rotation_y_deg += \
				_input_axis_coefficient_x * mouse_pos_offset.x \
				* _MOUSE_SENSITIVITY
		_target_rotation_x_deg += \
				_input_axis_coefficient_y * mouse_pos_offset.y \
				* _MOUSE_SENSITIVITY
		_target_rotation_x_deg = \
				clamp(_target_rotation_x_deg, \
				_ROTATION_LIMIT_Y_MIN, _ROTATION_LIMIT_Y_MAX)
		
	_current_camera_rotation_x_rad = lerp_angle(_current_camera_rotation_x_rad, \
			deg_to_rad(_target_rotation_x_deg), _LOOK_SMOOTH_WEIGHT)
	_current_camera_rotation_y_rad = lerp_angle(_current_camera_rotation_y_rad, \
			deg_to_rad(_target_rotation_y_deg), _LOOK_SMOOTH_WEIGHT)
	
	rotation = Vector3(_current_camera_rotation_x_rad, \
			_current_camera_rotation_y_rad, 0.0)

func set_target(target : Node3D) -> void:
	_target = target
