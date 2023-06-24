class_name QuickMenuUIInventory
extends QuickMenuUIBase

signal drop_requested(count : int)

@onready var _eat_button = \
		$ControlWithOffset/ButtonsContainer/EatButton
@onready var _drop_button = $ControlWithOffset/ButtonsContainer/DropButton
@onready var _cancel_button = $ControlWithOffset/ButtonsContainer/CancelButton

var _current_inventory_slot : InventorySlot

func show_for_slot(slot : InventorySlot) -> void:
	_current_inventory_slot = slot
	global_position = slot.global_position
	visible = true
	
	_connect_buttons_pressed_signals()
	
	quick_menu_visible.emit()

func hide_and_reset() -> void:
	_disconnect_buttons_pressed_signals()
	
	visible = false
	position = Vector2.ZERO
	_current_inventory_slot = null
	
	quick_menu_hidden.emit()

func _focus_first_button() -> void:
	_drop_button.grab_focus()

func _connect_buttons_pressed_signals() -> void:
	_cancel_button.pressed.connect(hide_and_reset)
	_drop_button.pressed.connect(_drop_items)

func _disconnect_buttons_pressed_signals() -> void:
	_cancel_button.pressed.disconnect(hide_and_reset)
	_drop_button.pressed.disconnect(_drop_items)

func _drop_items():
	drop_requested.emit(1)
