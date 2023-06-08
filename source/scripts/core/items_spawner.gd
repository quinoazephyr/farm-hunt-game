class_name ItemsSpawner
extends Node

@export var _pool_size : int
@export var _items_packed_scenes : Array[PackedScene]

var _items_resources : Dictionary # [int, PackedScene]
var _items_loaded_pool : Dictionary # [int, Array[Item3D]]

func _ready() -> void:
	for rsc in _items_packed_scenes:
		var item = rsc.instantiate()
		var item_id = item._item.id
		_items_resources[item_id] = rsc
		_items_loaded_pool[item_id] = []
		item.queue_free()

func spawn(item_id : int, position : Vector3, rotation : Quaternion) -> Item3D:
	var loaded_item = _get_loaded_item(item_id)
	add_child(loaded_item)
	loaded_item.position = position
	loaded_item.quaternion = rotation
	return loaded_item

func despawn(item : Item3D):
	if item.get_parent() == self:
		remove_child(item)
		var item_id = item._item.id
		_items_loaded_pool[item_id].append(item)

func _get_loaded_item(item_id : int) -> Item3D:
	if _items_loaded_pool[item_id].size() > 0:
		return _items_loaded_pool[item_id].pop_back()
	_load_item_pool(item_id)
	return _items_loaded_pool[item_id].pop_back()

func _load_item_pool(item_id : int) -> void:
	var item_resource = _get_item_resource(item_id)
	assert(item_resource != null)
	for i in range(0, _pool_size):
		var loaded_item = item_resource.instantiate()
		_items_loaded_pool[item_id].append(loaded_item)

func _get_item_resource(item_id : int) -> PackedScene:
	return _items_resources[item_id]
