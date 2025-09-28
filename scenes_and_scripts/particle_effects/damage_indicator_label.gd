extends Node3D
class_name DamageIndicatorLabel

@onready var label: Label = $SubViewport/Label

func set_value(value:int):
	print(label)
	label.text = str(value)
	label.add_theme_color_override("font_color",_get_indicator_color(value))
func _get_indicator_color(value):
	if value > 0:return Color.RED
	elif value < 0: return Color.GREEN
	else: return Color.GRAY
func change_font_size(font_size):
	label.add_theme_font_size_override("font_size", font_size)
	
