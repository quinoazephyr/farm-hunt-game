class_name QuestGoalEnterArea
extends QuestGoalBase

@export var _area_name : String

var _area : Area3D

func start(root_node : Node) -> void:
	_area = root_node.get_node(_area_name)
	_area.body_entered.connect(_complete_if_player)
	
	super.start(root_node)

func _complete_if_player(body : Node3D) -> void:
	if body is PlayerCharacter:
		complete()
