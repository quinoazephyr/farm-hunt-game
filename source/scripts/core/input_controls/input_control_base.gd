class_name InputControlBase
extends Node

@onready var _default_process_mode = process_mode
@onready var _viewport = get_viewport()

func activate() -> void:
	process_mode = _default_process_mode

func deactivate() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func force_activate() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
