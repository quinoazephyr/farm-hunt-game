class_name PlayerInventorySynchronizer
extends Node

@export_node_path("CharacterWithBag") var _player_character_node_path
@export_node_path("InventoryUI") var _inventory_ui_path

@onready var _inventory = get_node(_player_character_node_path)._inventory
@onready var _inventory_ui = get_node(_inventory_ui_path)

func _ready():
	_inventory.items_added.connect(_inventory_ui.add_items)
	_inventory_ui.drop_items_requested.connect(_inventory.remove_items)
