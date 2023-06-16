class_name InventorySlot
extends Control

signal was_selected

var is_empty:
	get:
		return _item_id == TypeConstants.OUT_OF_BOUNDS
var item_name:
	get:
		return _name
var item_description:
	get:
		return _description
var item_count:
	get:
		return _count

var _item_id : int = TypeConstants.OUT_OF_BOUNDS
var _name : String = ""
var _description : String = ""
var _count : int = 0

@onready var _button_slot = $"."
@onready var _count_label = $CountLabel
@onready var _item_texture_rect = $ItemImage
@onready var _item_full_texture_rect = $ItemFull
@onready var _item_empty_texture_rect = $ItemEmpty
@onready var _highlight_node = $Highlight

func _ready():
	_button_slot.pressed.connect(_emit_selected)
	focus_entered.connect(highlight.bind(true))
	focus_exited.connect(highlight.bind(false))

func has_exact_item(item : Item) -> bool:
	if is_empty:
		return false
	return item.id == _item_id

func set_item(item : Item) -> void:
	_item_id = item.id
	_item_texture_rect.texture = item.image
	_item_full_texture_rect.visible = true
	_item_empty_texture_rect.visible = false
	_name = item.name
	_description = item.description
	_count_label.visible = true
	highlight(false)

func reset() -> void:
	_item_id = TypeConstants.OUT_OF_BOUNDS
	_name = ""
	_description = ""
	_count = 0
	_count_label.text = str(_count)
	_item_texture_rect.texture = null
	_item_full_texture_rect.visible = false
	_item_empty_texture_rect.visible = true
	
	_count_label.visible = false
	
	highlight(false)

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
