class_name MenuInputControls
extends Node

@export_node_path("TimescaleControl") var _timescale_control_path
@export_node_path("PlayerCharacter") var _player_character_node_path
@export_node_path("PauseUI") var _pause_ui_path

@onready var _timescale_control = get_node(_timescale_control_path)
@onready var _player_character = get_node(_player_character_node_path)
@onready var _pause_ui = get_node(_pause_ui_path)
@onready var _action_input_control = $ActionInputControl

func _ready() -> void:
	_timescale_control.paused.connect(_pause_ui.open)
	_pause_ui.closed.connect(_timescale_control.play)
	_pause_ui.set_controls(_action_input_control)
