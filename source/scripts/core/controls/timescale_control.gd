class_name TimescaleControl
extends Node

signal paused
signal unpaused

var is_paused:
	set(value):
		_is_paused = value
		_tree_node.paused = _is_paused
		if _is_paused:
			paused.emit()
		else:
			unpaused.emit()
	get:
		return _is_paused

var _is_paused : bool = false

@onready var _tree_node = get_tree()

func pause() -> void:
	self.is_paused = true

func play() -> void:
	self.is_paused = false
