extends Node2D
class_name Canvas

func _ready() -> void:
	_initialize_window()

func _initialize_window() -> void:

	var window: Window = get_window()

	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()
	window.always_on_top = true
	window.unresizable = true
