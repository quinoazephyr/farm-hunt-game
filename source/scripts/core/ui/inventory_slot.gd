class_name InventorySlot
extends Control

signal was_selected

var is_empty:
	get:
		return _item == null
var item_description:
	get:
		return "" if is_empty else _item.description
var item_count:
	get:
		return _count

var _item : Item = null
var _count : int = 0

@onready var _button_slot = $"."
@onready var _name_label = $NameLabel
@onready var _count_container = $Count
@onready var _count_label = $Count/CountLabel
@onready var _image_texture_rect = $Image
@onready var _highlight_node = $Highlight

func _ready():
	_button_slot.pressed.connect(_emit_selected)
	focus_entered.connect(highlight.bind(true))
	focus_exited.connect(highlight.bind(false))

func has_exact_item(item : Item) -> bool:
	if is_empty:
		return false
	return item.id == _item.id

func set_item(item : Item) -> void:
	_item = item
	_name_label.text = item.name
	_image_texture_rect.texture = item.image
	_name_label.visible = true
	_count_container.visible = true

func reset() -> void:
	_item = null
	_count = 0
	_name_label.text = ""
	_count_label.text = str(0)
	_image_texture_rect.texture = null
	
	_name_label.visible = false
	_count_container.visible = false

func add_items(count : int) -> void:
	_count += count
	_count_label.text = str(_count)

func remove_items(count : int) -> void:
	_count -= count
	_count_label.text = str(_count)

func highlight(enable : bool) -> void:
	_highlight_node.visible = enable

func _emit_selected() -> void:
	was_selected.emit()
