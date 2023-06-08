class_name InventoryUI
extends CanvasItem

signal inventory_focused
signal quick_menu_focused
signal drop_items_requested(items : Item, count : int)
signal inventory_opened
signal inventory_closed

var is_open:
	get:
		return visible

var _slots : Array[InventorySlot]
var _current_focused_slot : InventorySlot

@onready var _slots_container = $SlotsContainer
@onready var _description_label = $Description
@onready var _quick_menu = $QuickMenu

func _ready() -> void:
	var slot_nodes = _slots_container.get_children()
	for node in slot_nodes:
		node.focus_entered.connect(_fill_item_description.bind(node))
		node.focus_entered.connect(_set_current_focused_slot.bind(node))
		_slots.append(node)
	
	_quick_menu.quick_menu_visible.connect(_set_focus_to_quick_menu)
	_quick_menu.quick_menu_hidden.connect(_set_focus_to_inventory)
	
	_quick_menu.drop_requested.connect(_drop_items)

func add_item(item : Item) -> void:
	add_items(item, 1)

func add_items(items : Item, count : int) -> void:
	var inventory_slot = _get_suitable_inventory_slot(items)
	if inventory_slot.is_empty:
		inventory_slot.set_item(items)
	inventory_slot.add_items(count)

#func remove_item(item : Item) -> void:
#	var inventory_slot = _get_suitable_inventory_slot(item)
#	remove_child(inventory_slot)
#	inventory_slot.queue_free()

func remove_items_from_current_slot(count : int) -> void:
	drop_items_requested.emit(_current_focused_slot._item, count)

func call_menu_on_current_slot():
	if _current_focused_slot.is_empty:
		return
	
	_quick_menu.show_for_slot(_current_focused_slot)

func close_menu():
	_quick_menu.hide_and_reset()

func open_inventory():
	_set_slots_focusable()
	_focus_first_slot()
	visible = true
	inventory_opened.emit()
	inventory_focused.emit()

func _drop_items(count : int) -> void:
	remove_items_from_current_slot(count)
	close_menu()
	close_inventory()

func close_inventory():
	_current_focused_slot = null
	_set_slots_non_focusable()
	visible = false
	inventory_closed.emit()

func _set_focus_to_quick_menu():
	_set_slots_non_focusable()
	_current_focused_slot.highlight(true)
	quick_menu_focused.emit()

func _set_focus_to_inventory():
	_set_slots_focusable()
	_current_focused_slot.grab_focus()
	inventory_focused.emit()

func _get_suitable_inventory_slot(item : Item) -> InventorySlot:
	for slot in _slots:
		if slot.has_exact_item(item):
			return slot
	for slot in _slots:
		if slot.is_empty:
			return slot
	assert(false)
	return null

func _focus_first_slot() -> void:
	var first_slot = _slots.front()
	first_slot.grab_focus()

func _fill_item_description(slot : InventorySlot) -> void:
	_description_label.text = slot.item_description 

func _set_current_focused_slot(slot : InventorySlot) -> void:
	_current_focused_slot = slot

func _set_slots_focusable():
	for slot in _slots:
		slot.focus_mode = Control.FOCUS_ALL

func _set_slots_non_focusable():
	for slot in _slots:
		slot.focus_mode = Control.FOCUS_NONE
