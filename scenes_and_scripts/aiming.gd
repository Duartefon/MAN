extends Node3D


@onready var camera: Camera3D = $"../../Camera3D"

func _physics_process(delta: float) -> void:
	_look_at_crosshair()
	
func _look_at_crosshair() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_target
	
	var space_state = get_world_3d().direct_space_state
	var intersection = space_state.intersect_ray(params)
	  

	if intersection:
 
		var world_position = intersection.position
		var look_at_me = Vector3(world_position.x, global_position.y, world_position.z )
		 
		 
