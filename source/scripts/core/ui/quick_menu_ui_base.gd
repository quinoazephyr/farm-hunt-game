class_name QuickMenuUIBase
extends Control

signal quick_menu_visible
signal quick_menu_hidden

var is_open:
	get:
		return visible

func _ready() -> void:
	visibility_changed.connect(_focus_first_button)

func _focus_first_button() -> void:
	pass

func _connect_buttons_pressed_signals() -> void:
	pass

func _disconnect_buttons_pressed_signals() -> void:
	pass
