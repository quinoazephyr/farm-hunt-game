class_name Inventory

signal resized(new_size : int)
signal items_added(item : Item, count : int, slot_index : int)
signal items_removed(item : Item, count : int, slot_index : int)

var _items_details : Array[Inventory.ItemDetails]

func init(size : int) -> void:
	resize(size)

func add_items(item : Item, count : int) -> void:
	var slot_index = _get_item_slot_index(item.id)
	if slot_index == TypeConstants.OUT_OF_BOUNDS:
		return
	_items_details[slot_index].item = item
	_items_details[slot_index].count += count
	items_added.emit(item, count, slot_index)

func remove_items(slot_index : int, count : int) -> void:
	_items_details[slot_index].count = \
			max(0, _items_details[slot_index].count - count)
	items_removed.emit(_items_details[slot_index].item, count, slot_index)
	if _items_details[slot_index].count == 0:
		_items_details[slot_index].item == null

func resize(new_size : int) -> void:
	var old_size = _items_details.size()
	_items_details.resize(new_size)
	if new_size > old_size:
		for i in range(old_size, new_size):
			var item_details = Inventory.ItemDetails.new()
			_items_details[i] = item_details
	resized.emit(new_size)

func get_count_remaining_for_item(item_id : int) -> int: # how many items can fit into inventory
	var slot_index = _get_item_slot_index(item_id)
	if slot_index == TypeConstants.OUT_OF_BOUNDS:
		return 0
	return _items_details[slot_index].item.max_count - \
			_items_details[slot_index].count

func _get_item_slot_index(item_id : int) -> int:
	for i in range(0, _items_details.size()):
		if _items_details[i].item != null &&\
				_items_details[i].item.id == item_id:
			return i
	for i in range(0, _items_details.size()):
		if _items_details[i].count == 0:
			return i
	return TypeConstants.OUT_OF_BOUNDS

class ItemDetails:
	var item : Item = null
	var count : int = 0
