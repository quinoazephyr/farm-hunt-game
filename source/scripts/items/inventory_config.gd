class_name InventoryConfig
extends Resource

enum InventoryType {
	RESOURCE,
	EQUIPMENT
}

@export var _type : InventoryType
@export var _default_size : int = 1
@export var _can_auto_join_items : bool
@export var _auto_resize_increment_value : int # can auto resize if can join items

var type:
	get:
		return _type
var default_size:
	get:
		return _default_size
var can_auto_join_items:
	get:
		return _can_auto_join_items
var is_auto_resizable:
	get:
		return can_auto_join_items && _auto_resize_increment_value > 0
var auto_resize_increment_value:
	get:
		return _auto_resize_increment_value
