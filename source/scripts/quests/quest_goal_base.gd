class_name QuestGoalBase
extends Resource

signal completed

@export var _title : String
@export_multiline var _description : String

var title:
	get:
		return _title
var description:
	get:
		return _description

func start(root_node : Node) -> void:
	pass

func complete() -> void:
	completed.emit()
