class_name CharacterWithBag
extends CharacterWithItemAwareness

signal inventory_resized(inventory_index : int, new_size : int)
signal inventory_items_arranged(new_slots_indices : Array[int], \
		inventory_index : int)
signal items_added_to_inventory(item : Item, count : int, \
		inventory_index : int, slot_index : int)
signal items_dropped_from_inventory(item : Item, count : int, \
		inventory_index : int, slot_index : int)
signal picked_up_item(item : Item)

@export var _inventories_configs : Array[InventoryConfig]

var _inventories : Dictionary # [InventoryType, Inventory]

func _ready() -> void:
	super._ready()
	
	for i in range(0, _inventories_configs.size()):
		var config = _inventories_configs[i]
		var inventory = Inventory.new()
		inventory.resized.connect(_emit_inventory_resized.bind(i))
		inventory.items_arranged.connect(_emit_inventory_items_arranged.bind(i))
		inventory.items_added.connect(_emit_items_added.bind(i))
		inventory.items_removed.connect(_emit_items_dropped.bind(i))
		inventory.init(config)
		_inventories[int(config.type)] = inventory

func pick_up_closest_item() -> void:
	if _is_close_items_processing_requested:
		var item = _closest_item._item # sometimes null
		var inventory = _inventories[item.type]
		inventory.items_added\
				.connect(_on_picked_up_items_added_to_inventory.unbind(3))
		inventory.try_add_items(item, 1)
		inventory.items_added\
				.disconnect(_on_picked_up_items_added_to_inventory.unbind(3))

func _remove_items_from_inventory(count : int, inventory_index : int, \
		slot_index : int) -> void:
	_inventories[inventory_index].remove_items(slot_index, count)

func _on_picked_up_items_added_to_inventory() -> void:
	picked_up_item.emit(_closest_item)
	_reset_closest_item()

func _emit_items_added(items : Item, count : int, slot_index : int, \
		inventory_index : int) -> void:
	items_added_to_inventory.emit(items, count, inventory_index, slot_index)

func _emit_items_dropped(items : Item, count : int, slot_index : int, \
		inventory_index : int) -> void:
	items_dropped_from_inventory.emit(items, count, inventory_index, slot_index)

func _emit_inventory_resized(new_size : int, inventory_index : int) -> void:
	inventory_resized.emit(inventory_index, new_size)

func _emit_inventory_items_arranged(new_slots_indices : Array[int], \
		inventory_index : int) -> void:
	inventory_items_arranged.emit(inventory_index, new_slots_indices)
