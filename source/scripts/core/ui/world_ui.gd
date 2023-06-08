class_name WorldUI
extends Node

@export_node_path("PlayerCharacter") var _player_character_node_path

@onready var _player_character = get_node(_player_character_node_path)
@onready var _pick_up_action_ui = $PickUpActionGraphic
@onready var _screen_space_label = $ScreenSpaceLabel
@onready var _quests_ui = $QuestsScrollBox

func _ready() -> void:
	_player_character.found_closest_item.connect(_show_screen_space_label)
	_player_character.no_items_close_detected\
			.connect(_screen_space_label.hide_label)
	
	_player_character.found_closest_item\
			.connect(_pick_up_action_ui.show.unbind(1))
	_player_character.no_items_close_detected.connect(_pick_up_action_ui.hide)
	
	_player_character.quest_accepted.connect(_quests_ui.add_quest)

func _show_screen_space_label(item : Item3D) -> void:
	_screen_space_label.show_label(item.global_transform.origin, item._item.name)
