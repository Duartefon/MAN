extends CharacterBody3D

@export var speed = 150
var target_velocity = Vector3.ZERO

@export var fall_acceleration = 75

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
