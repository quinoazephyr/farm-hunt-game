class_name QuestUI
extends CanvasItem

@export var _goal_packed_scene : PackedScene

@onready var _title = $Title
@onready var _description = $Description
@onready var _goals_container = $Goals

func set_quest(quest : QuestBase) -> void:
	_title.text = quest.title
	_description.text = quest.description
	for goal in quest._goals:
		var goal_ui = _goal_packed_scene.instantiate()
		_goals_container.add_child(goal_ui)
		goal_ui.set_goal(goal)
	
	quest.finished.connect(_on_finished)

func _on_finished() -> void:
	_title.text = "✔ " + _title.text
