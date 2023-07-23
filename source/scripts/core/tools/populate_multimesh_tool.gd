@tool
class_name PopulateMultimeshTool
extends Node

@export var _instance_count : int = 65536
@export var _instance_scale : float = 1.0
@export var _use_colors : bool = false
@export var _multimesh_node : MultiMeshInstance3D
@export var _target_surface_mesh_node : MeshInstance3D
@export var _source_mesh_node : MeshInstance3D
@export var _height_map : Texture2D
@export var _button_placeholder : bool

func populate_surface():
	_populate_surface(_multimesh_node, _target_surface_mesh_node, \
			_source_mesh_node.mesh, _instance_count, _instance_scale, _use_colors)

func _populate_surface(multimesh_node : MultiMeshInstance3D, 
		target_surface : MeshInstance3D, source_mesh : Mesh, 
		instance_count : int, instance_scale : float, use_colors : bool) -> void:
	var geom_xform = multimesh_node.global_transform.affine_inverse() * \
			target_surface.global_transform
	var geometry = target_surface.mesh.get_faces()
	var faces : Array[Array] = []
	for i in range(0, geometry.size(), 3):
		var vertices = [geometry[i], geometry[i + 1], geometry[i + 2]]
		faces.push_back(vertices)
	
	var faces_size = faces.size()
	for f in faces_size:
		for v in faces[f].size():
			faces[f][v] = faces[f][v] * geom_xform
	
	var area_accum = 0.0
	var triangle_area_map : Dictionary # [float, int]
	for f in faces_size:
		var area = _get_face_area(faces[f])
		if area < 0.00001:
			continue
		triangle_area_map[area_accum] = f
		area_accum += area
	
	var multimesh_new : MultiMesh = MultiMesh.new()
	multimesh_new.mesh = source_mesh
	multimesh_new.transform_format = MultiMesh.TRANSFORM_3D
	multimesh_new.use_colors = use_colors
	multimesh_new.instance_count = instance_count
	
	
	var target_surface_aabb = target_surface.get_aabb()
	var span = (target_surface_aabb.size + Vector3.ONE * 0.05) / 2.0
	var height_map_image = _height_map.get_image()
	
	for i in instance_count:
		var areapos = randf_range(0.0, area_accum)
		var index = _find_closest_area_index(triangle_area_map, 
				0, triangle_area_map.size() - 1, areapos)
		var face = faces[index]
		var pos = _get_random_point_inside(face)
		
		# Grass area extends over (-span, span) - ie. width/length is 2*span
		var pos_relative = Vector3.ZERO
		pos_relative.x = (pos.x + span.x) / span.x / 2.0
		pos_relative.z = (pos.z + span.z) / span.z / 2.0
		var height = height_map_image.get_pixel(pos_relative.x * height_map_image.get_width(), 
				pos_relative.z * height_map_image.get_height())
		if height.r < 0.1:
			continue
		
		var normal = Plane(face[0], face[1], face[2]).normal
		var op_axis = (face[0] - face[1]).normalized()
		
		var axis_xform : Transform3D
		var xform : Transform3D
		xform = xform.translated(pos)
		xform = xform.looking_at(pos + op_axis, normal)
		xform = xform * axis_xform

		var post_xform : Basis
		post_xform = \
				post_xform.rotated(xform.basis.y, -randf_range(-1.0, 1.0) * PI)
		xform.basis = post_xform * xform.basis
		
		xform.basis = xform.basis.scaled(Vector3.ONE * instance_scale * height.r)
		
		multimesh_new.set_instance_transform(i, xform)
	
	multimesh_node.multimesh = multimesh_new

func _get_face_area(vertices):
	return ((vertices[0] - vertices[1]) * 
			(vertices[0] - vertices[2])).length() * 0.5

func _get_random_point_inside(vertices):
	var a = randf_range(0.0, 1.0)
	var b = randf_range(0.0, 1.0)
	if a > b:
		var t = a
		a = b
		b = t

	return vertices[0] * a + vertices[1] * (b - a) + vertices[2] * (1.0 - b)

func _find_closest_area_index(dic, key_l, key_r, val_x) -> int:
	var keys = dic.keys()
	var prev
	while key_l <= key_r:
		var key_mid = key_l + (key_r - key_l) / 2
		prev = keys[key_mid]
		if keys[key_mid] == val_x:
			break
		elif val_x < keys[key_mid]:
			key_r = key_mid - 1
		else:
			key_l = key_mid + 1
	return dic[prev]
