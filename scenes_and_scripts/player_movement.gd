extends CharacterBody3D

@export var speed = 300

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
	# Get mouse position and create a ray from the camera
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos) * 500
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction)
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if !ray_result.is_empty():
		var target_position = ray_result.position
		
		# Only calculate rotation on the horizontal (X-Z) plane
		var direction = (target_position - global_transform.origin).normalized()
		var angle = atan2(direction.x, direction.z)
		
		# Apply the rotation to the player's Y-axis
		rotation.y = angle 

		 
		
