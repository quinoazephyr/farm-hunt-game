class_name PauseUI
extends Node

signal opened
signal closed

@export_node_path("PlayerCharacter") var _player_character_node_path

@onready var _player_character = get_node(_player_character_node_path)
@onready var _inventory_ui = $InventoryUI

func _ready():
	_player_character.inventory_resized.connect(_inventory_ui.resize_tab)
	_player_character.inventory_items_arranged.connect(_inventory_ui.arrange_items)
	_player_character.items_added_to_inventory.connect(_inventory_ui.add_items)
	_inventory_ui.drop_items_requested.\
			connect(_player_character._remove_items_from_inventory)

func open():
	_inventory_ui.open_inventory()
	opened.emit()

func close():
	_inventory_ui.close_inventory()
	closed.emit()

func set_controls(action_input_control : ActionInputControl) -> void:
	_inventory_ui.closed.connect(_emit_closed) # todo: while "pause" is ONLY inventory
	_inventory_ui.closed\
			.connect(_disconnect_inventory_controls.bind(action_input_control))
	_inventory_ui.self_focused\
			.connect(_set_controls_on_inventory.bind(action_input_control))
	_inventory_ui.slot_menu_focused\
			.connect(_set_controls_on_inventory_slot_menu\
			.bind(action_input_control))

func _set_controls_on_inventory(\
		action_input_control : ActionInputControl) -> void:
	if _is_quick_menu_controls_connected(action_input_control):
		_disconnect_quick_menu_controls(action_input_control)
	
	action_input_control.cancel_requested.connect(close)
	action_input_control.accept_requested\
			.connect(_inventory_ui.call_menu_on_current_slot)
	action_input_control.ui_accept_requested\
			.connect(_inventory_ui.call_menu_on_current_slot)

func _set_controls_on_inventory_slot_menu(\
		action_input_control : ActionInputControl) -> void:
	if _is_inventory_controls_connected(action_input_control):
		_disconnect_inventory_controls(action_input_control)
	
	action_input_control.cancel_requested.connect(_inventory_ui.close_menu)

func _disconnect_inventory_controls(\
		action_input_control : ActionInputControl) -> void:
	action_input_control.cancel_requested.disconnect(close)
	action_input_control.accept_requested\
			.disconnect(_inventory_ui.call_menu_on_current_slot)
	action_input_control.ui_accept_requested\
			.disconnect(_inventory_ui.call_menu_on_current_slot)

func _disconnect_quick_menu_controls(\
		action_input_control : ActionInputControl) -> void:
	action_input_control.cancel_requested\
		.disconnect(_inventory_ui.close_menu)

func _is_inventory_controls_connected(\
		action_input_control : ActionInputControl) -> bool:
	return action_input_control.cancel_requested\
			.is_connected(close)

func _is_quick_menu_controls_connected(\
		action_input_control : ActionInputControl) -> bool:
	return action_input_control.cancel_requested\
			.is_connected(_inventory_ui.close_menu)

func _emit_closed():
	closed.emit()
