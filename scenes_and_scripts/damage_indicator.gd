extends Node3D

@export var offset := Vector3.UP
@export var font_size := 200
@export var labelRange := 3.5
@export var animationDuration := 0.9

const DAMAGE_INDICATOR_LABEL = preload("uid://chcgbgfb07e7b")
 
func create_indicator_label(value):
	var indicatorLabel: DamageIndicatorLabel = DAMAGE_INDICATOR_LABEL.instantiate()
	
	get_tree().current_scene.add_child(indicatorLabel)
	indicatorLabel.set_value(value)
	indicatorLabel.change_font_size(font_size)
	indicatorLabel.global_position = global_position + offset
	
	_tween_indicator(indicatorLabel)
	
func _tween_indicator(label):
	var tween:Tween = create_tween()
	var randomTargetPosition = Vector3(
		randf_range(-labelRange,labelRange),
		randf_range(-labelRange,labelRange),
		randf_range(-labelRange,labelRange)
		)
	tween.tween_property(label, "position", label.global_position + randomTargetPosition, animationDuration)
	
	tween.tween_callback(label.queue_free)
	
