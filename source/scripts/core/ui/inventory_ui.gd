class_name InventoryUI
extends CanvasItem

signal self_focused
signal slot_menu_focused
signal drop_items_requested(slot_index : int, count : int)
signal opened
signal closed

const _RESOURCE_TAB_INDEX = 0
const _EQUIPMENT_TAB_INDEX = 1

var is_open:
	get:
		return visible

var _tabs_slots : Dictionary # [int, Array[InventorySlot]]
var _tabs_slots_containers : Array[Container]
var _current_focused_slot_index : int

@onready var _next_tab_button = $TabsRect/InputR
@onready var _prev_tab_button = $TabsRect/InputL
@onready var _tab_bar = $TabsRect/TabBar
@onready var _tab_container = $TabContainer
@onready var _name_label = $DescriptionRect/Name
@onready var _description_label = $DescriptionRect/Description
@onready var _quick_menu = $QuickMenu

func _ready() -> void:
	_tab_container.tab_changed.connect(_tab_bar.set_current_tab)
	_tab_bar.tab_clicked.connect(_tab_container.set_current_tab)
	
	_next_tab_button.pressed.connect(_open_next_tab)
	_prev_tab_button.pressed.connect(_open_previous_tab)
	
	var tab_count = _tab_container.get_tab_count()
	for i in range(0, tab_count):
		_tabs_slots_containers.append(_tab_container.get_child(i))
		_init_tab_slots(i)
	for i in range(0, tab_count):
		_set_tab_slots_focus_neighbours(i)
	
	_quick_menu.quick_menu_visible.connect(_set_focus_to_quick_menu)
	_quick_menu.quick_menu_hidden.connect(_set_focus_to_inventory)
	
	_quick_menu.drop_requested.connect(_drop_items)

func add_resources(items : Item, count : int, slot_index : int) -> void:
	var inventory_slot = _tabs_slots[_RESOURCE_TAB_INDEX][slot_index]
	if inventory_slot.is_empty:
		inventory_slot.set_item(items)
	inventory_slot.add_items(count)

func remove_items_from_slot(slot_index : int, count : int) -> void:
	drop_items_requested.emit(slot_index, count)

func call_menu_on_current_slot():
	var current_slot = \
			_tabs_slots[_tab_container.current_tab][_current_focused_slot_index]
	if  current_slot.is_empty:
		return
	
	_quick_menu.show_for_slot(current_slot)

func close_menu():
	_quick_menu.hide_and_reset()

func open_inventory():
	_set_slots_focusable()
	_focus_slot_in_tab(_RESOURCE_TAB_INDEX, 0)
	_tab_container.current_tab = _RESOURCE_TAB_INDEX
	visible = true
	opened.emit()
	self_focused.emit()

func close_inventory() -> void:
	_current_focused_slot_index = TypeConstants.OUT_OF_BOUNDS
	_set_slots_non_focusable()
	visible = false
	closed.emit()

func _drop_items(count : int) -> void:
	remove_items_from_slot(_current_focused_slot_index, count)
	close_menu()
	close_inventory()

func _init_tab_slots(tab_index : int) -> void:
	if !_tabs_slots.has(tab_index):
		_tabs_slots[tab_index] = []
	
	var slots_container = _tabs_slots_containers[tab_index]
	var slot_nodes = slots_container.get_children()
	for i in range(0, slot_nodes.size()):
		var node = slot_nodes[i]
		node.focus_entered.connect(_fill_item_description.bind(node))
		node.focus_entered.connect(_set_current_focused_slot.bind(tab_index, i))
		_tabs_slots[tab_index].append(node)

func _set_tab_slots_focus_neighbours(tab_index : int) -> void:
	var slot_nodes = _tabs_slots[tab_index]
	var slot_columns = _tabs_slots_containers[tab_index].columns
	for i in range(0, slot_nodes.size()):
		var node = slot_nodes[i]
		
		var cur_column = i % slot_columns
		var cur_row = i / slot_columns
		var is_left_column = cur_column == 0
		var is_right_column = cur_column == slot_columns - 1
		
		node.focus_neighbor_left = "" if is_left_column \
				else slot_nodes[i - 1].get_path()
		node.focus_neighbor_right = "" if is_right_column \
				else slot_nodes[i + 1].get_path()
		node.focus_neighbor_top = "" if cur_row == 0 \
				else slot_nodes[i - slot_columns].get_path()
		node.focus_neighbor_bottom = "" \
				if cur_row == slot_nodes.size() / slot_columns - 1 \
				else slot_nodes[i + slot_columns].get_path() 
	
	var prev_tab_index = tab_index - 1
	if prev_tab_index > -1:
		var prev_slot_nodes = _tabs_slots[prev_tab_index]
		var prev_slot_columns = _tabs_slots_containers[prev_tab_index].columns
		var prev_slot_rows = prev_slot_nodes.size() / prev_slot_columns
		for i in range(0, slot_nodes.size(), slot_columns):
			var cur_slot = slot_nodes[i]
			var cur_row = i / slot_nodes.size()
			var prev_slot_row = max(0, min(prev_slot_rows - 1, cur_row))
			var prev_slot_index = (prev_slot_row + 1) * prev_slot_columns - 1
			cur_slot.focus_previous = \
					prev_slot_nodes[prev_slot_index].get_path()
	
	var next_tab_index = tab_index + 1
	if next_tab_index < _tabs_slots_containers.size():
		var next_slot_nodes = _tabs_slots[next_tab_index]
		var next_slot_columns = _tabs_slots_containers[next_tab_index].columns
		var next_slot_rows = next_slot_nodes.size() / next_slot_columns
		for i in range(slot_columns - 1, slot_nodes.size(), slot_columns):
			var cur_slot = slot_nodes[i]
			var cur_row = i / slot_nodes.size()
			var next_slot_row = max(0, min(next_slot_rows - 1, cur_row))
			cur_slot.focus_next = \
					next_slot_nodes[next_slot_row].get_path()

func _set_focus_to_quick_menu() -> void:
	_set_slots_non_focusable()
	var current_slot = \
			_tabs_slots[_tab_container.current_tab][_current_focused_slot_index]
	current_slot.highlight(true)
	slot_menu_focused.emit()

func _set_focus_to_inventory() -> void:
	_set_slots_focusable()
	var current_slot = \
			_tabs_slots[_tab_container.current_tab][_current_focused_slot_index]
	current_slot.grab_focus()
	self_focused.emit()

func _focus_slot_in_tab(tab_index : int, slot_index : int) -> void:
	var first_slot = _tabs_slots[tab_index][slot_index]
	first_slot.grab_focus()

func _fill_item_description(slot : InventorySlot) -> void:
	_name_label.text = slot.item_name
	_description_label.text = slot.item_description 

func _set_current_focused_slot(tab_index : int, slot_index : int) -> void:
	_current_focused_slot_index = slot_index
	_tab_container.current_tab = tab_index

func _set_slots_focusable() -> void:
	for i in range(0, _tab_container.get_tab_count()):
		var slots = _tabs_slots[i]
		for slot in slots:
			slot.focus_mode = Control.FOCUS_ALL

func _set_slots_non_focusable() -> void:
	for i in range(0, _tab_container.get_tab_count()):
		var slots = _tabs_slots[i]
		for slot in slots:
			slot.focus_mode = Control.FOCUS_NONE

func _open_next_tab() -> void:
	_tab_container.current_tab = \
			min(_tab_container.current_tab + 1, \
			_tab_container.get_tab_count() - 1)

func _open_previous_tab() -> void:
	_tab_container.current_tab = \
			max(_tab_container.current_tab - 1, 0)
