class_name QuestsIssuer

var is_quest_available:
	get:
		return _quests.size() > 0

var _quests : Array[QuestBase]

func set_quests(quests : Array[QuestBase]) -> void:
	_quests = quests

func get_first_quest() -> QuestBase:
	return _quests.pop_front()

func get_last_quest() -> QuestBase:
	return _quests.pop_back()
