class_name CharacterBase
extends RigidBody3D

var _movement_velocity : Vector3
var _point_looking_at : Vector3 = Vector3.FORWARD
var _is_jump_requested : bool = false

func _ready() -> void:
	_point_looking_at = global_position + Vector3.FORWARD

func _integrate_forces(state) -> void:
	var old_velocity_y = state.linear_velocity.y
	state.linear_velocity = _movement_velocity
	state.linear_velocity.y = old_velocity_y
	
	if _movement_velocity.length_squared() > 0:
		_point_looking_at = global_position + state.linear_velocity
	look_at(_point_looking_at)
	
	if _is_jump_requested: # todo: add ground check
		state.apply_central_impulse(Vector3.UP * 2.5)
		_is_jump_requested = false
	
	# lock rotation
	rotation = Vector3(0.0, rotation.y, 0.0)

func _process_movement(velocity) -> void:
	pass

func _process_jump() -> void:
	_is_jump_requested = true
