extends Camera3D

@export var player: NodePath
@export var distance := 5.0
@export var height := 6.0
@export var follow_speed := 2.0
@export var mouse_influence := 0.3
@export var max_mouse_distance := 8.0

@onready var player_node: CharacterBody3D = get_node(player)

func _process(delta):
	if not player_node:
		return
	
	var player_pos = player_node.global_transform.origin
	var mouse_offset = get_mouse_world_offset()
	
	var base_camera_pos = player_pos + Vector3(0, height, -distance)
	var target_pos = base_camera_pos + mouse_offset * mouse_influence
	global_transform.origin = global_transform.origin.lerp(target_pos, delta * follow_speed)
	
	look_at(player_pos, Vector3.UP)

func get_mouse_world_offset() -> Vector3:
	var mouse_pos_2d = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_normalized = Vector2(
		(mouse_pos_2d.x / viewport_size.x - 0.5) * 2.0,
		(mouse_pos_2d.y / viewport_size.y - 0.5) * 2.0
	)
	var scale_factor = height * 0.4
	var mouse_offset = Vector3(-mouse_normalized.x * scale_factor, 0, -mouse_normalized.y * scale_factor)
	
	if mouse_offset.length() > max_mouse_distance:
		mouse_offset = mouse_offset.normalized() * max_mouse_distance
	return mouse_offset
