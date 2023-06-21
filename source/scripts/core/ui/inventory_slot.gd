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
@onready var _highlight_empty_node = $HighlightEmpty
@onready var _highlight_full_node = $HighlightFull

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
	_name = item.name
	_description = item.description
	_count = 0
	_count_label.text = str(_count)
	_count_label.visible = true
	_item_texture_rect.texture = item.image
	_item_full_texture_rect.visible = true
	_item_empty_texture_rect.visible = false
	highlight(false)

func reset() -> void:
	_item_id = TypeConstants.OUT_OF_BOUNDS
	_name = ""
	_description = ""
	_count = 0
	_count_label.visible = false
	_count_label.text = str(_count)
	_item_texture_rect.texture = null
	_item_full_texture_rect.visible = false
	_item_empty_texture_rect.visible = true
	highlight(false)

func copy(slot : InventorySlot) -> void:
	_item_id = slot._item_id
	_name = slot._name
	_description = slot._description
	_count = slot._count
	_count_label.text = str(_count)
	_count_label.visible = slot._count_label.visible
	_item_texture_rect.texture = slot._item_texture_rect.texture
	_item_full_texture_rect.visible = slot._item_full_texture_rect.visible
	_item_empty_texture_rect.visible = slot._item_empty_texture_rect.visible
	highlight(false)

static func swap(slot_0 : InventorySlot, slot_1 : InventorySlot) -> void:
	var t = slot_0
	var t_item_id = t._item_id
	var t_name = t._name
	var t_description = t._description
	var t_count = t._count
	var t_count_label_visible = t._count_label.visible
	var t_item_texture_rect_texture = t._item_texture_rect.texture
	var t_item_full_texture_rect_visible = t._item_full_texture_rect.visible
	var t_item_empty_texture_rect_visible = t._item_empty_texture_rect.visible
	
	slot_0.copy(slot_1)
	
	slot_1._item_id = t_item_id
	slot_1._name = t_name
	slot_1._description = t_description
	slot_1._count = t_count
	slot_1._count_label.text = str(t_count)
	slot_1._count_label.visible = t_count_label_visible
	slot_1._item_texture_rect.texture = t_item_texture_rect_texture
	slot_1._item_full_texture_rect.visible = t_item_full_texture_rect_visible
	slot_1._item_empty_texture_rect.visible = t_item_empty_texture_rect_visible

func add_items(count : int) -> void:
	_count += count
	_count_label.text = str(_count)

func remove_items(count : int) -> void:
	_count -= count
	_count_label.text = str(_count)

func highlight(enable : bool) -> void:
	_highlight_empty_node.visible = enable
	_highlight_full_node.visible = !is_empty && enable

func _emit_selected() -> void:
	was_selected.emit()
