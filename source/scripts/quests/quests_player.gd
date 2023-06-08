class_name QuestsPlayer

signal quest_accepted(quest : QuestBase)
signal quest_completed(quest : QuestBase)

var _quests_started : Array[QuestBase]
var _quests_finished : Array[QuestBase]

func accept_quest(quest : QuestBase, root_node : Node) -> void:
	_quests_started.append(quest)
	quest.started.connect(_emit_quest_accepted.bind(quest))
	quest.finished.connect(_emit_quest_completed.bind(quest))
	quest.start(root_node)

func force_complete_quest(quest : QuestBase) -> void:
	quest.force_finish()

func _emit_quest_accepted(quest : QuestBase) -> void:
	quest_accepted.emit(quest)

func _emit_quest_completed(quest : QuestBase) -> void:
	quest_completed.emit(quest)
