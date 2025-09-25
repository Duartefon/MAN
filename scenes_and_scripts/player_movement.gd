extends CharacterBody3D

#@export var speed = 300

@onready var camera: Camera3D = $"../Camera3D"

@export var speed = 14 # How fast the player moves
@export var h_accelerate = 8 # How fast the player speeds up in the horizontal plane
@export var h_desaccelerate = 8 # How fast the player slows down in the horizontal plane
@export var fall_acceleration = 75 # How fast the player falls down

var target_velocity = Vector3.ZERO
var horizontal_velocity = Vector3.ZERO

 



 
	
func _physics_process(delta):
	# Obtain player inputs
	var direction = Vector3.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	#Normalize so that diagonal speed isnt greater than straight speed
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Obtain Targeted horizontal velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if target_velocity.length()>0: # Accelerate smoothly towards the Targeted horizontal velocity
		horizontal_velocity.x = move_toward(horizontal_velocity.x, target_velocity.x, h_accelerate*delta)
		horizontal_velocity.z = move_toward(horizontal_velocity.z, target_velocity.z, h_accelerate*delta)
	else: 	# Desaccelerate smoothly when there is none Targeted horizontal velocity
		horizontal_velocity.x = move_toward(horizontal_velocity.x, target_velocity.x, h_desaccelerate*delta)
		horizontal_velocity.z = move_toward(horizontal_velocity.z, target_velocity.z, h_desaccelerate*delta)
		
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor.
		velocity.y -= fall_acceleration * delta
	else:
		velocity.y = 0

	# Moving the Character
	velocity = horizontal_velocity
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

		 
		
