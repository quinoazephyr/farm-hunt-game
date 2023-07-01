class_name WorldInputControls
extends Node

@export_node_path("TimescaleControl") var _timescale_control_path
@export_node_path("PlayerCharacter") var _player_character_node_path
@export_node_path("WorldUI") var _world_ui_path

@onready var _timescale_control = get_node(_timescale_control_path)
@onready var _player_character = get_node(_player_character_node_path)
@onready var _world_ui = get_node(_world_ui_path)
@onready var _movement_input_control = $MovementInputControl
@onready var _action_input_control = $ActionInputControl

func _ready() -> void:
	_action_input_control.cancel_requested.connect(_timescale_control.pause)
	_timescale_control.paused.connect(_world_ui.hide)
	_timescale_control.unpaused.connect(_world_ui.show)
	
	_action_input_control.action_x_requested\
			.connect(_player_character._process_jump)
	_action_input_control.accept_requested\
			.connect(_player_character.pick_up_closest_item)

func _process(delta : float) -> void:
	_player_character._process_movement(_movement_input_control.get_input_axis())
