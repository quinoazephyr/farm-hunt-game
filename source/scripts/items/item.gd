class_name Item
extends Resource

var id:
	get:
		return _id
var name:
	get:
		return _name
var description:
	get:
		return _description
var max_count:
	get:
		return _max_count
var type:
	get:
		return _type
var image:
	get:
		return _image

@export var _id = TypeConstants.OUT_OF_BOUNDS
@export var _name : String
@export_multiline var _description : String
@export var _max_count = 999
@export var _type = InventoryConfig.InventoryType.RESOURCE 
@export var _image : Texture2D
