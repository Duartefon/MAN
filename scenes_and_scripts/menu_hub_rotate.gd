extends Node3D

# --- EXPORTS VARIABLES ---
# Drag Marker3D nodes here from the scene tree
@export var menu_points: Array[Marker3D] = [] # Array of Marker3D nodes representing selectable menu positions
# How fast is the rotation
@export var animation_speed: float = 0.2

# --- ONREADY NODES ---
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var infobox_title: Label = $UI/Infobox/MarginContainer/VBoxContainer/title
@onready var infobox_desc: Label = $UI/Infobox/MarginContainer/VBoxContainer/description
@onready var confirm_box: PanelContainer = $UI/confirm_box

# --- STATE VARIABLES ---
var current_index: int = 0 # Index of the selected menu point set to first point
var is_animating: bool = false # Prevents input spam during animation

func _ready() -> void:
	confirm_box.hide() # Hide the confirmation box at the start
	select_point(current_index, false) # Aligns the camera pivot to the first point

func _input(event: InputEvent) -> void:
	# Don't allow input if an animation is playing
	if is_animating:
		return
		
	var new_index := current_index
	# Move selection point right
	if event.is_action_pressed("ui_right"):
		new_index = (current_index + 1) % menu_points.size()
	# Move selection point left
	elif event.is_action_pressed("ui_left"):
		new_index = (current_index - 1 + menu_points.size()) % menu_points.size()
	
	# If index changed, update selection point
	if new_index != current_index:
		select_point(new_index)
		
	# Show confirmation box when the player presses the selection point
	if event.is_action_pressed("ui_accept"):
		confirm_box.show()

func select_point(index: int, animate: bool = true) -> void:
	# Set the current index and obtain the associated point
	current_index = index
	var selected_point: Marker3D = menu_points[current_index]
	
	# Calculate angle so the camera looks at the selected point
	var dir: Vector3 = (selected_point.global_position - camera_pivot.global_position).normalized()
	# Y-axis rotation only, atan2(x, z) returns angle around Y
	var target_angle_y: float = atan2(dir.x, dir.z)
	
	# Update UI with metadata stored on the point
	_update_infobox(selected_point)
	
	# If no animation requested, instantly snap the pivot
	if not animate:
		var rot = camera_pivot.rotation
		rot.y = target_angle_y
		camera_pivot.rotation = rot
		return

	# Calculate to shortest rotation path
	var angle_diff := wrapf(target_angle_y - camera_pivot.rotation.y, -PI, PI)
	var final_angle := camera_pivot.rotation.y + angle_diff
	
# --- Animate using a Tween ---
	is_animating = true
	var tween := create_tween()
	# Animate the pivot's rotation
	tween.tween_property(camera_pivot, "rotation:y", final_angle, animation_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# When the tween finishes, allow input again
	await tween.finished
	is_animating = false

func _update_infobox(point: Marker3D) -> void:
	 # Read metadata keys "title" and "description" from the point and fill in UI labels
	infobox_title.text = point.get_meta("title", "No Title")
	infobox_desc.text = point.get_meta("description", "No description available.")

func _on_yes_button_pressed() -> void:
	# When confirmed, get the scene path from the currently selected point's metadata.
	var scene_path = menu_points[current_index].get_meta("scene_path")
	if not scene_path or scene_path.is_empty():
		print("ERROR: No scene_path defined for this menu point!")
		return
	
	# Load the new scene
	get_tree().change_scene_to_file(scene_path)

func _on_no_button_pressed() -> void:
	# Hide the confirmation box when the player cancels
	confirm_box.hide()
