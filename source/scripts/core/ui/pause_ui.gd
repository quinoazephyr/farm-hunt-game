class_name PauseUI
extends Node

@export_node_path("PlayerCharacter") var _player_character_node_path

@onready var _player_character = get_node(_player_character_node_path)
@onready var _inventory_ui = $InventoryUI

func _ready():
	var inventory = _player_character._inventory
	inventory.items_added.connect(_inventory_ui.add_items)
	_inventory_ui.drop_items_requested.connect(inventory.remove_items)
