class_name QuestGoalUI
extends CanvasItem

@onready var _status_label = $StatusLabel
@onready var _title = $Title

func set_goal(goal : QuestGoalBase) -> void:
	_title.text = goal.title
	goal.completed.connect(_on_completed)

func _on_completed() -> void:
	_status_label.text = " ✔ "
