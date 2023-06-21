class_name InventoryConfig
extends Resource

enum InventoryType {
	RESOURCE,
	EQUIPMENT
}

@export var _type : InventoryType
@export var _initial_size : int
@export var _auto_resize_increment_value : int

var type:
	get:
		return _type
var initial_size:
	get:
		return _initial_size
var is_auto_resizable:
	get:
		return _auto_resize_increment_value > 0
var auto_resize_increment_value:
	get:
		return _auto_resize_increment_value
