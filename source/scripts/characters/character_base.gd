class_name CharacterBase
extends RigidBody3D

@export var _angular_speed : float = 10.0

var _movement_velocity : Vector3
var _point_looking_at : Vector3 = Vector3.FORWARD
var _is_jump_requested : bool = false
var _leg_ray_length : float = 1.0
var _animation_player : AnimationPlayer = null

func _ready() -> void:
	_point_looking_at = global_position + Vector3.FORWARD

func _integrate_forces(state) -> void:
	var old_velocity_y = state.linear_velocity.y
	state.linear_velocity = _movement_velocity
	state.linear_velocity.y = old_velocity_y
	
	var angular_y = 0.0
	if _movement_velocity.length_squared() > 0:
		_point_looking_at = global_position + state.linear_velocity
		var new_transform = transform.looking_at(_point_looking_at)
		var new_quaternion = new_transform.basis.get_rotation_quaternion()
		var delta = new_quaternion * quaternion.inverse()
		var delta_angle = delta.get_euler().y
		angular_y = delta_angle * _angular_speed
	state.angular_velocity.y = angular_y
	
	if _is_jump_requested: # todo: add ground check
		var result = _intersect_leg_ray()
		if result:
			state.apply_central_impulse(Vector3.UP * 2.5)
		_is_jump_requested = false
	
	# lock rotation
	rotation = Vector3(0.0, rotation.y, 0.0)

func _process_movement(velocity) -> void:
	pass

func _process_jump() -> void:
	_is_jump_requested = true

func _intersect_leg_ray() -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D\
			.create(global_transform.origin, \
			global_transform.origin - Vector3.ONE * _leg_ray_length)
	query.exclude = [self]
	return space_state.intersect_ray(query)

func _process_animations() -> void:
	pass

func _play_animation(name : StringName) -> void:
	_animation_player.play(name)

func _stop_animation() -> void:
	_animation_player.stop()
