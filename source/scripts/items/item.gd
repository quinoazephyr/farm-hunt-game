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
var image:
	get:
		return _image

@export var _id : int
@export var _name : String
@export_multiline var _description : String
@export var _image : Texture2D
