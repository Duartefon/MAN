extends CharacterBody3D

@export var speed = 150

@onready var camera: Camera3D = $"../Camera3D"

@export var fall_acceleration = 75

 

var target_velocity = Vector3.ZERO


 
	
func _physics_process(delta):
	var direction = Vector3.ZERO
	direction.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Ground Velocity
	target_velocity.x = direction.x * speed 
	target_velocity.z = direction.z * speed 

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor.
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity * delta
	move_and_slide()
func _process(delta: float) -> void:
 
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = ray_origin + camera.project_ray_normal(mouse_pos) * 500
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_direction)
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if !ray_result.is_empty():

		if ray_result.collider != self:
			var target_position = ray_result.position
			target_position.y += 2.0  # Adjust this value to point 1 meter above the hit point
 
			look_at(-target_position)

		 
		
