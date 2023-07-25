class_name InventoryUITabs
extends CanvasItem

signal slot_focus_entered(slot : InventorySlot)
signal slot_focus_exited(slot : InventorySlot)
signal drop_items_requested(count : int, tab_index : int, slot_index : int)

const _DEFAULT_TAB_INDEX = 0

@export var _slot_packed_scene : PackedScene
@export var _tabs_icons_active : Array[Texture2D]
@export var _tabs_icons_inactive : Array[Texture2D]

var current_slot:
	get:
		return _tabs_slots\
				[_tab_container.current_tab][_current_focused_slot_index]

var _tabs_slots : Dictionary # [int, Array[InventorySlot]]
var _tabs_slots_containers : Array[Container]
var _current_focused_slot_index : int

@onready var _next_tab_button = $TabsRect/InputR
@onready var _prev_tab_button = $TabsRect/InputL
@onready var _tab_bar = $TabsRect/TabBar # DO NOT get .current_tab here
@onready var _tab_container = $TabContainerMask/TabContainer # GET .current_tab HERE
@onready var _tab_label_container = $TabLabel
@onready var _tab_label = $TabLabel/Label

func _ready() -> void:
	_tab_container.tab_changed.connect(_tab_bar.set_current_tab)
	_tab_bar.tab_clicked.connect(_tab_container.set_current_tab)
	_tab_bar.tab_clicked.connect(_focus_slot_in_current_tab.bind(0).unbind(1))
	_tab_bar.tab_selected.connect(_update_tabs_modulate_colors)
	
	_next_tab_button.pressed.connect(_open_next_tab)
	_prev_tab_button.pressed.connect(_open_previous_tab)

func add_items(items : Item, count : int, \
		tab_index : int, slot_index : int) -> void:
	var inventory_slot = _tabs_slots[tab_index][slot_index]
	if inventory_slot.is_empty:
		inventory_slot.set_item(items)
	inventory_slot.add_items(count)

func remove_items(count : int, tab_index : int, slot_index : int) -> void:
	var slot = _tabs_slots[tab_index][slot_index]
	slot.remove_items(count)
	if slot.item_count == 0:
		slot.reset()
	drop_items_requested.emit(tab_index, slot_index, count)

func resize_tab(tab_index : int, new_size : int) -> void:
	if tab_index >= _tabs_slots_containers.size():
		var scroll_container = _tab_container.get_child(tab_index)
		var slots_container = scroll_container.get_child(0)
		_tabs_slots_containers.append(slots_container)
		_tabs_slots[tab_index] = []
	
	var container = _tabs_slots_containers[tab_index]
	var slot_array = _tabs_slots[tab_index]
	var old_size = slot_array.size()
	
	if old_size < new_size:
		for i in range(old_size, new_size):
			var slot = _slot_packed_scene.instantiate()
			container.add_child(slot)
			slot.focus_entered.connect(_emit_slot_focus_entered.bind(slot))
			slot.focus_entered.connect(_set_current_focused_slot.bind(tab_index, i))
			slot.focus_exited.connect(_emit_slot_focus_exited.bind(slot))
			slot_array.append(slot)
	elif new_size < old_size:
		for i in range(old_size - 1, new_size - 1, -1):
			var slot = slot_array[i]
			container.remove_child(slot)
		slot_array.resize(new_size)
	
	for i in range(max(0, tab_index - 1), \
			min(tab_index + 1, _tab_container.get_tab_count())):
		_set_tab_slots_focus_neighbours(i)

func arrange_items(tab_index : int, \
		new_slots_indices : Array[int]) -> void:
	var slots = _tabs_slots[tab_index]
	for i in range(0, new_slots_indices.size()):
		var swap_to_index = new_slots_indices[i]
		InventorySlot.swap(slots[i], slots[swap_to_index])

func remove_items_from_current_slot(count : int) -> void:
	remove_items(count, _tab_container.current_tab, _current_focused_slot_index)

func set_slots_focusable() -> void:
	for i in range(0, _tab_container.get_tab_count()):
		var slots = _tabs_slots[i]
		for slot in slots:
			slot.focus_mode = Control.FOCUS_ALL

func set_slots_non_focusable() -> void:
	for i in range(0, _tab_container.get_tab_count()):
		var slots = _tabs_slots[i]
		for slot in slots:
			slot.focus_mode = Control.FOCUS_NONE

func grab_default_slot_focus() -> void:
	_focus_slot_in_tab(_DEFAULT_TAB_INDEX, 0)
	_tab_container.current_tab = _DEFAULT_TAB_INDEX

func release_current_slot_focus() -> void:
	current_slot.release_focus()
	_current_focused_slot_index = TypeConstants.OUT_OF_BOUNDS

func _set_tab_slots_focus_neighbours(tab_index : int) -> void:
	var prev_tab_index = tab_index - 1
	var prev_tab_nodes : Array
	var prev_tab_columns : int
	var prev_tab_rows : int
	var prev_tab_exists = prev_tab_index > TypeConstants.OUT_OF_BOUNDS
	if prev_tab_exists:
		prev_tab_nodes = _tabs_slots[prev_tab_index]
		prev_tab_columns = \
				min(_tabs_slots_containers[prev_tab_index].columns,
				_tabs_slots_containers[prev_tab_index].get_child_count())
		prev_tab_rows = ceili(prev_tab_nodes.size() / float(prev_tab_columns))
	
	var next_tab_index = tab_index + 1
	var next_tab_nodes : Array
	var next_tab_columns : int
	var next_tab_rows : int
	var next_tab_exists = next_tab_index < _tabs_slots_containers.size()
	if next_tab_exists:
		next_tab_nodes = _tabs_slots[next_tab_index]
		next_tab_columns = \
				min(_tabs_slots_containers[next_tab_index].columns,
				_tabs_slots_containers[next_tab_index].get_child_count())
		next_tab_rows = ceili(next_tab_nodes.size() / float(next_tab_columns))
	
	var cur_tab_nodes = _tabs_slots[tab_index]
	var cur_tab_columns = _tabs_slots_containers[tab_index].columns
	var cur_tab_rows = ceili(cur_tab_nodes.size() / float(cur_tab_columns))
	for i in range(0, cur_tab_nodes.size()):
		var node = cur_tab_nodes[i]
		var cur_tab_column = i % cur_tab_columns
		var cur_tab_row = i / cur_tab_columns
		var is_left_column = cur_tab_column == 0
		var is_right_column = cur_tab_column == cur_tab_columns - 1
		
		node.focus_neighbor_left = "" \
				if is_left_column || i - 1 < 0 \
				else cur_tab_nodes[i - 1].get_path()
		node.focus_neighbor_right = "" \
				if is_right_column || i + 1 >= cur_tab_nodes.size() \
				else cur_tab_nodes[i + 1].get_path()
		node.focus_neighbor_top = "" \
				if cur_tab_row == 0 \
				else cur_tab_nodes[i - cur_tab_columns].get_path()
		node.focus_neighbor_bottom = "" \
				if cur_tab_row == cur_tab_rows - 1 || \
				i + cur_tab_columns >= cur_tab_nodes.size() \
				else cur_tab_nodes[i + cur_tab_columns].get_path()
		
		if prev_tab_exists:
			var prev_tab_column = max(0, min(prev_tab_columns - 1, cur_tab_column))
			var prev_tab_row = max(0, min(prev_tab_rows - 1, cur_tab_row))
			var prev_tab_corresponding_slot_index = \
					prev_tab_row * prev_tab_columns + prev_tab_column
			node.focus_previous = \
					prev_tab_nodes[prev_tab_corresponding_slot_index].get_path()
		else:
			node.focus_previous = node.get_path()
		if next_tab_exists:
			var next_tab_column = max(0, min(next_tab_columns - 1, cur_tab_column))
			var next_tab_row = max(0, min(next_tab_rows - 1, cur_tab_row))
			var next_tab_corresponding_slot_index = \
					next_tab_row * next_tab_columns + next_tab_column
			node.focus_next = \
					next_tab_nodes[next_tab_corresponding_slot_index].get_path()
		else:
			node.focus_next = node.get_path()
	
	if prev_tab_exists:
		for i in range(0, cur_tab_nodes.size(), cur_tab_columns):
			var cur_slot = cur_tab_nodes[i]
			var cur_row = i / cur_tab_columns
			var prev_tab_row = max(0, min(prev_tab_rows - 1, cur_row))
			var prev_slot_index : int
			if prev_tab_row == prev_tab_rows - 1:
				prev_slot_index = prev_tab_nodes.size() - 1
			else:
				prev_slot_index = \
						prev_tab_row * prev_tab_columns + \
						prev_tab_columns - 1
			cur_slot.focus_neighbor_left = \
					prev_tab_nodes[prev_slot_index].get_path()
	
	if next_tab_exists:
		for i in range(cur_tab_columns - 1, cur_tab_nodes.size(), cur_tab_columns):
			var cur_slot = cur_tab_nodes[i]
			var cur_row = i / cur_tab_columns
			var next_slot_row = max(0, min(next_tab_rows - 1, cur_row))
			var next_slot_index = next_slot_row * next_tab_columns
			cur_slot.focus_neighbor_right = \
					next_tab_nodes[next_slot_index].get_path()
		if cur_tab_columns * cur_tab_rows > cur_tab_nodes.size():
			var next_slot_row = max(0, min(next_tab_rows - 1, cur_tab_rows - 1))
			var next_slot_index = next_slot_row * next_tab_columns
			cur_tab_nodes[cur_tab_nodes.size() - 1].focus_neighbor_right = \
					next_tab_nodes[next_slot_index].get_path()

func _focus_slot_in_tab(tab_index : int, slot_index : int) -> void:
	var slot = _tabs_slots[tab_index][slot_index]
	slot.grab_focus()
	_update_tabs_modulate_colors(_tab_bar.current_tab)

func _focus_slot_in_current_tab(slot_index : int) -> void:
	_focus_slot_in_tab(_tab_container.current_tab, slot_index)

func _open_next_tab() -> void:
	var current_slot = \
			_tabs_slots[_tab_container.current_tab][_current_focused_slot_index]
	var focus_next_slot_path = current_slot.focus_next
	_tab_container.current_tab = \
			min(_tab_container.current_tab + 1, \
			_tab_container.get_tab_count() - 1)
	get_node(focus_next_slot_path).grab_focus()

func _open_previous_tab() -> void:
	var current_slot = \
			_tabs_slots[_tab_container.current_tab][_current_focused_slot_index]
	var focus_prev_slot_path = current_slot.focus_previous
	_tab_container.current_tab = \
			max(_tab_container.current_tab - 1, 0)
	get_node(focus_prev_slot_path).grab_focus()

func _set_current_focused_slot(tab_index : int, slot_index : int) -> void:
	_current_focused_slot_index = slot_index
	_tab_container.current_tab = tab_index

func _update_tabs_modulate_colors(selected_tab_index : int) -> void:
	for i in range(0, _tab_bar.tab_count):
		var icons_array = _tabs_icons_active \
				if i == selected_tab_index \
				else _tabs_icons_inactive
		_tab_bar.set_tab_icon(i, icons_array[i])
		if i == selected_tab_index:
			var tab_rect = _tab_bar.get_tab_rect(i)
			# STUB
			var offset = _tab_bar.global_position \
					if _tab_bar.global_position.x > 100.0 \
					else Vector2(100.0, 0.0) + _tab_bar.global_position
			# ####
			_tab_label_container.position = \
					offset + tab_rect.position
			_tab_label.text = _tab_bar.get_tab_title(i)

func _emit_slot_focus_entered(slot : InventorySlot) -> void:
	slot_focus_entered.emit(slot)

func _emit_slot_focus_exited(slot : InventorySlot) -> void:
	slot_focus_exited.emit(slot)
