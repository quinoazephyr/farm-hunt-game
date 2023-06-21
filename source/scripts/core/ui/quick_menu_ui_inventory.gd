class_name QuickMenuUIInventory
extends QuickMenuUIBase

signal drop_requested(count : int)

@onready var _hold_more_button = \
		$ControlWithOffset/ButtonsContainer/HoldMoreButton
@onready var _hold_less_button = \
		$ControlWithOffset/ButtonsContainer/HoldLessButton
@onready var _drop_button = $ControlWithOffset/ButtonsContainer/DropButton
@onready var _cancel_button = $ControlWithOffset/ButtonsContainer/CancelButton
@onready var _hold_count_rect = $ControlWithOffset/CountRect
@onready var _hold_count_label = \
		$ControlWithOffset/CountRect/CountLabel

var _current_inventory_slot : InventorySlot
var _items_count_holding : int

func show_for_slot(slot : InventorySlot) -> void:
	_current_inventory_slot = slot
	_items_count_holding = 0
	_update_hold_count_graphic()
	_update_hold_buttons_disabled_state()
	_drop_button.disabled = true
	global_position = slot.global_position
	visible = true
	
	_connect_buttons_pressed_signals()
	
	quick_menu_visible.emit()

func hide_and_reset() -> void:
	_disconnect_buttons_pressed_signals()
	
	visible = false
	position = Vector2.ZERO
	_items_count_holding = 0
	_update_hold_count_graphic()
	_update_hold_buttons_disabled_state()
	_drop_button.disabled = true
	_current_inventory_slot = null
	
	quick_menu_hidden.emit()

func _focus_first_button() -> void:
	_hold_more_button.grab_focus()

func _connect_buttons_pressed_signals() -> void:
	_cancel_button.pressed.connect(hide_and_reset)
	_hold_more_button.pressed.connect(_increase_items_count)
	_hold_less_button.pressed.connect(_decrease_items_count)
	_drop_button.pressed.connect(_drop_items)

func _disconnect_buttons_pressed_signals() -> void:
	_cancel_button.pressed.disconnect(hide_and_reset)
	_hold_more_button.pressed.disconnect(_increase_items_count)
	_hold_less_button.pressed.disconnect(_decrease_items_count)
	_drop_button.pressed.disconnect(_drop_items)

func _increase_items_count():
	_items_count_holding = \
			min(_current_inventory_slot.item_count, _items_count_holding + 1)
	_update_hold_count_graphic()
	_update_hold_buttons_disabled_state()
	_drop_button.disabled = _items_count_holding == 0

func _decrease_items_count():
	_items_count_holding = max(0, _items_count_holding - 1)
	_update_hold_count_graphic()
	_update_hold_buttons_disabled_state()
	_drop_button.disabled = _items_count_holding == 0

func _update_hold_buttons_disabled_state():
	_hold_more_button.disabled =\
			 _items_count_holding == _current_inventory_slot.item_count
	_hold_less_button.disabled = _items_count_holding == 0

func _update_hold_count_graphic():
	_hold_count_rect.visible = _items_count_holding > 0
	_hold_count_label.text = str(_items_count_holding)

func _drop_items():
	_current_inventory_slot.remove_items(_items_count_holding)
	var slot = _current_inventory_slot
	drop_requested.emit(_items_count_holding)
	if slot.item_count == 0:
		slot.reset()
