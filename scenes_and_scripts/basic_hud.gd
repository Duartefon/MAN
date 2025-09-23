extends Node
const CROSSHAIR_SQUARE = preload("uid://v5aa0wwmt7xq")

func _ready() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR_SQUARE)
