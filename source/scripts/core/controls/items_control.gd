class_name ItemsControl
extends Node

@export_node_path("ItemsSpawner") var _item_spawner_path
@export_node_path("PlaceholderSpawner") var _placeholder_spawner_path
@export var _chars_with_bags_node_paths : Array[NodePath]

var _chars_with_bags : Array[CharacterWithBag]

@onready var _item_spawner = get_node(_item_spawner_path)
@onready var _placeholder_spawner = get_node(_placeholder_spawner_path)

func _ready() -> void:
	for node_path in _chars_with_bags_node_paths:
		var character = get_node(node_path)
		
		character.picked_up_item.connect(_item_spawner.despawn)
		character.picked_up_item.connect(_placeholder_spawner.despawn_node)
		
		character.items_dropped_from_inventory.\
				connect(_drop_items_near_character.bind(character))
		
		_chars_with_bags.append(character)
	
	# DEBUG BEGIN
	_placeholder_spawner.spawn_all_immediate()
	_placeholder_spawner.spawn_all()
	#DEBUG END

func _drop_items_near_character(item : Item, count : int, \
		inventory_index : int, slot_index : int, \
		character : CharacterWithBag) -> void:
	var character_forward = -character.global_transform.basis.z
	var distance = 1.0
	var position_in_front = character.global_transform.origin + \
			character_forward * distance
	for i in range(0, count):
		_item_spawner.spawn(item.id, position_in_front, Quaternion.IDENTITY)
