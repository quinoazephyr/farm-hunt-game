class_name InventoryUI
extends CanvasItem

signal self_focused
signal slot_menu_focused
signal drop_items_requested(count : int, tab_index : int, slot_index : int)
signal opened
signal closed

var is_open:
	get:
		return visible

@onready var _tabs = $Tabs
@onready var _description_rect = $DescriptionRect
@onready var _name_label = $DescriptionRect/Name
@onready var _description_label = $DescriptionRect/Description
@onready var _quick_menu = $QuickMenu
@onready var _background_overlay = $ContrastedBlur
@onready var _viewport = get_viewport()

func _ready() -> void:
	_tabs.slot_focus_entered.connect(_show_item_description)
	_tabs.drop_items_requested.connect(remove_items)
	
	_quick_menu.quick_menu_visible.connect(_set_focus_to_quick_menu)
	_quick_menu.quick_menu_hidden.connect(_set_focus_to_inventory)
	
	_quick_menu.drop_requested.connect(_drop_items)

func add_items(items : Item, count : int, \
		tab_index : int, slot_index : int) -> void:
	_tabs.add_items(items, count, tab_index, slot_index)

func remove_items(tab_index : int, slot_index : int, count : int) -> void:
	drop_items_requested.emit(count, tab_index, slot_index)

func resize_tab(tab_index : int, new_size : int) -> void:
	_tabs.resize_tab(tab_index, new_size)

func arrange_items(tab_index : int, \
		new_slots_indices : Array[int]) -> void:
	_tabs.arrange_items(tab_index, new_slots_indices)

func call_menu_on_current_slot():
	var current_slot = _tabs.current_slot
	if  current_slot.is_empty:
		return
	
	_quick_menu.show_for_slot(current_slot)

func close_menu():
	_quick_menu.hide_and_reset()

func open_inventory():
	_tabs.set_slots_focusable()
	_tabs.grab_default_slot_focus()
	
	var image = _viewport.get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	_background_overlay.material.set_shader_parameter("_texture", texture)
	
	visible = true
	opened.emit()
	self_focused.emit()

func close_inventory() -> void:
	_tabs.release_current_slot_focus()
	_tabs.set_slots_non_focusable()
	visible = false
	closed.emit()

func _drop_items(count : int) -> void:
	_tabs.remove_items_from_current_slot(count)
	close_menu()
	close_inventory()

func _set_focus_to_quick_menu() -> void:
	_tabs.set_slots_non_focusable()
	var current_slot = _tabs.current_slot
	current_slot.highlight(true)
	slot_menu_focused.emit()

func _set_focus_to_inventory() -> void:
	_tabs.set_slots_focusable()
	var current_slot = _tabs.current_slot
	current_slot.grab_focus()
	self_focused.emit()

func _show_item_description(slot : InventorySlot) -> void:
	_description_rect.visible = !slot.is_empty
	_name_label.text = slot.item_name
	_description_label.text = slot.item_description 
