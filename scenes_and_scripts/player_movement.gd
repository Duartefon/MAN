extends CharacterBody3D

#@export var speed = 300

@onready var camera: Camera3D = $"../Camera3D"

@export var speed = 14 # How fast the player moves
@export var h_accelerate = 8 # How fast the player speeds up in the horizontal plane
@export var h_desaccelerate = 8 # How fast the player slows down in the horizontal plane
@export var fall_acceleration = 75 # How fast the player falls down

var target_velocity = Vector3.ZERO
var horizontal_velocity = Vector3.ZERO

@onready var man: Node3D = $man

@onready var ver_direcaodo_player: CSGBox3D = $verDirecaodoPlayer
var gun_script:Gun


func _ready() -> void:
	gun_script = $man.find_child("GunHolder")
	print(gun_script)

 
func _physics_process(delta):
	# Obtain player inputs
	var direction = Vector3.ZERO
	#print(direction, speed)
	direction.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	
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
	_look_at_crosshair()
	
	move_and_slide()
 
func _look_at_crosshair() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 100
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = ray_origin
	params.to = ray_target
	
	var space_state = get_world_3d().direct_space_state
	var intersection = space_state.intersect_ray(params)
	 
	if intersection:
		 
		var world_position = intersection.position
		var look_at_me = Vector3(world_position.x, position.y, world_position.z )
		look_at(look_at_me, Vector3.UP)
		 
func get_ammo():
	return gun_script.get_ammo()
	
