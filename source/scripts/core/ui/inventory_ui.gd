class_name InventoryUI
extends CanvasItem

signal self_focused
signal slot_menu_focused
signal drop_items_requested(slot_index : int, count : int)
signal opened
signal closed

var is_open:
	get:
		return visible

var _slots : Array[InventorySlot]
var _current_focused_slot_index : int

@onready var _slots_container = $ResourcesSlotsContainer
@onready var _name_label = $DescriptionRect/Name
@onready var _description_label = $DescriptionRect/Description
@onready var _quick_menu = $QuickMenu

func _ready() -> void:
	var slot_columns = _slots_container.columns
	var slot_nodes = _slots_container.get_children()
	for i in range(0, slot_nodes.size()):
		var node = slot_nodes[i]
		node.focus_entered.connect(_fill_item_description.bind(node))
		node.focus_entered.connect(_set_current_focused_slot.bind(i))
		
		# focus order
		node.focus_neighbor_left = "" if i % slot_columns == 0 \
				else slot_nodes[i - 1].get_path()
		node.focus_neighbor_right = "" if i % slot_columns == slot_columns - 1 \
				else slot_nodes[i + 1].get_path()
		node.focus_neighbor_top = "" if i < slot_columns \
				else slot_nodes[i - slot_columns].get_path()
		node.focus_neighbor_bottom = "" if i > slot_nodes.size() - 1 - slot_columns \
				else slot_nodes[i + slot_columns].get_path()
		
		_slots.append(node)
	
	_quick_menu.quick_menu_visible.connect(_set_focus_to_quick_menu)
	_quick_menu.quick_menu_hidden.connect(_set_focus_to_inventory)
	
	_quick_menu.drop_requested.connect(_drop_items)

func add_items(items : Item, count : int, slot_index : int) -> void:
	var inventory_slot = _slots[slot_index]
	if inventory_slot.is_empty:
		inventory_slot.set_item(items)
	inventory_slot.add_items(count)

func remove_items_from_slot(slot_index : int, count : int) -> void:
	drop_items_requested.emit(slot_index, count)

func call_menu_on_current_slot():
	if _slots[_current_focused_slot_index].is_empty:
		return
	
	_quick_menu.show_for_slot(_slots[_current_focused_slot_index])

func close_menu():
	_quick_menu.hide_and_reset()

func open_inventory():
	_set_slots_focusable()
	_focus_first_slot()
	visible = true
	opened.emit()
	self_focused.emit()

func _drop_items(count : int) -> void:
	remove_items_from_slot(_current_focused_slot_index, count)
	close_menu()
	close_inventory()

func close_inventory():
	_current_focused_slot_index = TypeConstants.OUT_OF_BOUNDS
	_set_slots_non_focusable()
	visible = false
	closed.emit()

func _set_focus_to_quick_menu():
	_set_slots_non_focusable()
	_slots[_current_focused_slot_index].highlight(true)
	slot_menu_focused.emit()

func _set_focus_to_inventory():
	_set_slots_focusable()
	_slots[_current_focused_slot_index].grab_focus()
	self_focused.emit()

func _focus_first_slot() -> void:
	var first_slot = _slots.front()
	first_slot.grab_focus()

func _fill_item_description(slot : InventorySlot) -> void:
	_name_label.text = slot.item_name
	_description_label.text = slot.item_description 

func _set_current_focused_slot(slot_index : int) -> void:
	_current_focused_slot_index = slot_index

func _set_slots_focusable():
	for slot in _slots:
		slot.focus_mode = Control.FOCUS_ALL

func _set_slots_non_focusable():
	for slot in _slots:
		slot.focus_mode = Control.FOCUS_NONE
