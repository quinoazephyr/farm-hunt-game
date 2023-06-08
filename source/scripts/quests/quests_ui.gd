class_name QuestsUI
extends CanvasItem

@export var _quest_packed_scene : PackedScene

var _quests_uis : Array[QuestUI]

@onready var _quests_container = $List

func add_quest(quest : QuestBase) -> void:
	var quest_ui = _quest_packed_scene.instantiate()
	_quests_container.add_child(quest_ui)
	quest_ui.set_quest(quest)
	_quests_uis.append(quest_ui)

func remove_quest(quest : QuestBase) -> void:
	pass
