class_name Inventory

signal resized(new_size : int)
signal items_added(item : Item, count : int, slot_index : int)
signal items_removed(item : Item, count : int, slot_index : int)
signal items_arranged(new_slots_indices : Array[int])

var _items_details : Array[Inventory.ItemDetails]
var _config : InventoryConfig

func init(inventory_config : InventoryConfig) -> void:
	_config = inventory_config
	resize(_config.default_size)

func try_add_items(item : Item, count : int) -> void:
	var slot_index = _get_item_slot_index(item.id)
	if slot_index == TypeConstants.OUT_OF_BOUNDS:
		return
	var can_add_count = _get_count_remaining_for_item(item.id)
	if can_add_count == 0:
		return
	var result_add_count = min(can_add_count, count)
	_items_details[slot_index].item = item
	_items_details[slot_index].count += result_add_count
	items_added.emit(item, result_add_count, slot_index)
	_join_items()
	_try_auto_resize()

func remove_items(slot_index : int, count : int) -> void:
	_items_details[slot_index].count = \
			max(0, _items_details[slot_index].count - count)
	items_removed.emit(_items_details[slot_index].item, count, slot_index)
	if _items_details[slot_index].count == 0:
		_items_details[slot_index].item = null
	_join_items()
	_try_auto_resize()

func resize(new_size : int) -> void:
	var old_size = _items_details.size()
	var increment_to_complete_row = \
			(_config.auto_resize_increment_value - \
			new_size % _config.auto_resize_increment_value) % \
			_config.auto_resize_increment_value \
			if _config.is_auto_resizable \
			else 0
	if old_size < new_size:
		new_size = new_size + increment_to_complete_row
		_items_details.resize(new_size)
		for i in range(old_size, new_size):
			var item_details = Inventory.ItemDetails.new()
			_items_details[i] = item_details
	elif new_size < old_size:
		new_size = max(_config.default_size, \
				new_size + increment_to_complete_row)
		for i in range(new_size, old_size):
			_items_details[i] = null
		_items_details.resize(new_size)
	resized.emit(new_size)

func _get_count_remaining_for_item(item_id : int) -> int: # how many items can fit into inventory
	var slot_index = _get_item_slot_index(item_id)
	if slot_index == TypeConstants.OUT_OF_BOUNDS:
		return 0
	if _items_details[slot_index].item == null:
		return TypeConstants.MAX_INT
	return _items_details[slot_index].item.max_count - \
			_items_details[slot_index].count

func _get_item_slot_index(item_id : int) -> int:
	for i in range(0, _items_details.size()):
		if _items_details[i].item != null &&\
				_items_details[i].item.id == item_id:
			return i
	for i in range(0, _items_details.size()):
		if _items_details[i].item == null:
			return i
	return TypeConstants.OUT_OF_BOUNDS

func _try_auto_resize() -> void:
	if _config.is_auto_resizable:
		var old_size = _items_details.size()
		var empty_slot_index = _get_item_slot_index(TypeConstants.OUT_OF_BOUNDS)
		var new_size = 0
		if empty_slot_index == TypeConstants.OUT_OF_BOUNDS:
			new_size = old_size + _config.auto_resize_increment_value
		else:
			new_size = empty_slot_index + 1
		resize(new_size)

func _join_items() -> void:
	if _config.can_auto_join_items:
		var slots_moved_indices : Array[int] = []
		slots_moved_indices.resize(_items_details.size())
		var empty_slots_indices = []
		for i in range(0, _items_details.size()):
			var item_index = i
			var item = _items_details[item_index]
			if item.item != null && empty_slots_indices.size() > 0:
				var last_empty_slot = empty_slots_indices.pop_front()
				_swap_items(item_index, last_empty_slot)
				slots_moved_indices[item_index] = last_empty_slot
				item = _items_details[item_index]
			else:
				slots_moved_indices[item_index] = item_index
			if item.item == null:
				empty_slots_indices.append(item_index)
		items_arranged.emit(slots_moved_indices)

func _swap_items(item_index_0 : int, item_index_1 : int) -> void:
	var item_0 = _items_details[item_index_0]
	var item_1 = _items_details[item_index_1]
	var t = _items_details[item_index_0]
	_items_details[item_index_0] = _items_details[item_index_1]
	_items_details[item_index_1] = t

class ItemDetails:
	var item : Item = null
	var count : int = 0
