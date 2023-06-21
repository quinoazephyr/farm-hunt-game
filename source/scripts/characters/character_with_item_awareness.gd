class_name CharacterWithItemAwareness
extends CharacterBase

signal found_closest_item(item : Item)
signal no_items_close_detected

var _items_close : Array[Item3D]
var _closest_item : Item3D
var _is_close_items_processing_requested : bool = false

@onready var _item_detection_area : Area3D = $ItemDetectionArea3D

func _ready() -> void:
	super._ready()
	
	_item_detection_area.body_entered.connect(_add_item_to_items_close)
	_item_detection_area.body_exited.connect(_remove_item_from_items_close)

func _process(delta) -> void:
	if _is_close_items_processing_requested:
		_process_close_items()

func _reset_closest_item() -> void:
	_closest_item = null
	
func _find_closest_item() -> Item3D:
	var min_distance = TypeConstants.MAX_INT
	var closest_item : Item3D = null
	for item in _items_close:
		var distance = (self.global_position - item.global_position).length()
		if distance < min_distance:
			min_distance = distance
			closest_item = item
	return closest_item

func _add_item_to_items_close(item) -> void:
	_items_close.append(item)
	_set_processing_close_items(true)

func _remove_item_from_items_close(item) -> void:
	var item_index = _items_close.find(item)
	if item_index != TypeConstants.OUT_OF_BOUNDS:
		_items_close.remove_at(item_index)
	_try_stop_processing_close_items()

func _try_stop_processing_close_items() -> void:
	if _items_close.size() == 0:
		no_items_close_detected.emit()
		_set_processing_close_items(false)

func _set_processing_close_items(enable) -> void:
	_is_close_items_processing_requested = enable

func _process_close_items() -> void:
	_closest_item = _find_closest_item()
	assert(_closest_item != null)
	found_closest_item.emit(_closest_item)
