class_name TestQuestIssuer
extends Node

@export var _quests : Array[QuestBase]

var _quests_issuer : QuestsIssuer

@onready var _player_character = $"../PlayerCharacter"

func _ready() -> void:
	_quests_issuer = QuestsIssuer.new()
	_quests_issuer.set_quests(_quests)
	if _quests_issuer.is_quest_available:
		_player_character.take_quest(_quests_issuer.get_first_quest())
