class_name MenuInputControls
extends Node

@export_node_path("TimescaleControl") var _timescale_control_path
@export_node_path("InventoryUI") var _inventory_ui_path

@onready var _timescale_control = get_node(_timescale_control_path)
@onready var _inventory_ui = get_node(_inventory_ui_path)
@onready var _action_input_control = $ActionInputControl

func _ready() -> void:
	_timescale_control.paused.connect(_toggle_inventory_ui)
	
	_inventory_ui.inventory_closed.connect(_timescale_control.play)
	_inventory_ui.inventory_closed.connect(_disconnect_inventory_controls)
	_inventory_ui.inventory_focused.connect(_set_controls_on_inventory)
	_inventory_ui.quick_menu_focused.connect(_set_controls_on_quick_menu)

func _toggle_inventory_ui() -> void:
	if _inventory_ui.is_open:
		_inventory_ui.close_inventory()
	else:
		_inventory_ui.open_inventory()

func _set_controls_on_inventory() -> void:
	if _is_quick_menu_controls_connected():
		_disconnect_quick_menu_controls()
	
	_action_input_control.cancel_requested.connect(_toggle_inventory_ui)
	_action_input_control.accept_requested\
			.connect(_inventory_ui.call_menu_on_current_slot)
	_action_input_control.ui_accept_requested\
			.connect(_inventory_ui.call_menu_on_current_slot)

func _set_controls_on_quick_menu() -> void:
	if _is_inventory_controls_connected():
		_disconnect_inventory_controls()
	
	_action_input_control.cancel_requested.connect(_inventory_ui.close_menu)

func _disconnect_inventory_controls() -> void:
	_action_input_control.cancel_requested.disconnect(_toggle_inventory_ui)
	_action_input_control.accept_requested\
			.disconnect(_inventory_ui.call_menu_on_current_slot)
	_action_input_control.ui_accept_requested\
			.disconnect(_inventory_ui.call_menu_on_current_slot)

func _disconnect_quick_menu_controls() -> void:
	_action_input_control.cancel_requested\
		.disconnect(_inventory_ui.close_menu)

func _is_inventory_controls_connected() -> bool:
	return _action_input_control.cancel_requested\
			.is_connected(_toggle_inventory_ui)

func _is_quick_menu_controls_connected() -> bool:
	return _action_input_control.cancel_requested\
			.is_connected(_inventory_ui.close_menu)
