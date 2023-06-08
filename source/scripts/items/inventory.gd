class_name Inventory

signal resized(new_size : int)
signal items_added(item : Item, count : int)
signal items_removed(items : Item, count : int)

func init(size : int) -> void:
	resize(size)

func add_items(item : Item, count : int) -> void:
	items_added.emit(item, count)

func remove_items(item : Item, count : int) -> void:
	var index = _find_item_index(item)
	if index != -1:
		pass
#		remove_items_by_index(index, count)
	items_removed.emit(item, count)

#func remove_items_by_index(index : int, count : int) -> void:
#	items_removed.emit(index, count)

func resize(new_size : int) -> void:
	pass

func _find_item_index(item : Item) -> int:
	return -1

func _is_inventory_full() -> bool:
	return false
