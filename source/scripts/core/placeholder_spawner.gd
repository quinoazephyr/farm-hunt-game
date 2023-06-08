class_name PlaceholderSpawner
extends Node

@export_node_path("Node") var _placeholders_parent_path
@export_node_path("Node") var _placeholders_spawned_parent_path
@export var _placeholders_immediate_paths : Array[NodePath]

var _placeholders : Array[Node]
var _placeholders_immediate : Array[Node3D]
var _placeholders_spawned : Array[Node3D]

@onready var _placeholders_parent = get_node(_placeholders_parent_path)
@onready var _placeholders_spawned_parent = \
		get_node(_placeholders_spawned_parent_path)

func _ready() -> void:
	_placeholders = _placeholders_parent.get_children()

func spawn_all() -> void: # todo: replace by chunk spawn
	for node in _placeholders:
		var node_spawned = node.create_instance()
		_placeholders_parent.remove_child(node_spawned)
		_placeholders_spawned_parent.add_child(node_spawned)
		_placeholders_spawned.append(node_spawned)

func spawn_all_immediate():
	for path in _placeholders_immediate_paths:
		var placeholder = get_node(path)
		var node_spawned = placeholder.create_instance(true)
		_placeholders_immediate.append(node_spawned)

func despawn_all() -> void: # todo: replace by chunk despawn
	for node_spawned in _placeholders_spawned:
		_placeholders_spawned_parent.remove_child(node_spawned)
		node_spawned.queue_free()

func despawn_node(node : Node3D) -> void:
	if node.get_parent() == _placeholders_spawned_parent:
		var index = _get_spawned_node_index(node)
		if index == -1:
			return
		_placeholders_spawned.remove_at(index)
		_placeholders_spawned_parent.remove_child(node)
		node.queue_free()

func _get_spawned_node_index(node : Node) -> int:
	for i in range(0, _placeholders_spawned.size()):
		if _placeholders_spawned[i] == node:
			return i
	return -1
