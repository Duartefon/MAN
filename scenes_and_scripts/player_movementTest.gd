extends CharacterBody3D

#@export var speed = 300

@onready var camera: Camera3D = $"../Camera3D"
@export var blend_speed = 10

@export var speed = 25
@export var h_accelerate = 50
@export var h_desaccelerate = 50

var target_velocity = Vector3.ZERO
var horizontal_velocity = Vector3.ZERO

@onready var man: Node3D = $man

@onready var ver_direcaodo_player: CSGBox3D = $verDirecaodoPlayer
@onready var anim_tree = $Man/AnimationPlayer/AnimationTree
var gun_script:Gun

#ANIM
enum {IDLE, RUN}
var curr_anim = IDLE
var run_val = 0
var hp = 100

func _ready() -> void:
	gun_script = $Man.find_child("GunHolder")
	print(gun_script)
	
func _physics_process(delta):
	var direction = Vector3.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if direction != Vector3.ZERO:
		direction = direction.normalized()


	target_velocity = direction * speed

	var accel = h_accelerate if direction != Vector3.ZERO else h_desaccelerate

	velocity.x = move_toward(velocity.x, target_velocity.x, accel * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, accel * delta)

	_look_at_crosshair()
	move_and_slide()

	var _move_input_2d = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	var is_moving = direction.length() > 0.1

	var is_shooting = Input.is_action_pressed("Shoot")
	anim_tree["parameters/RunAndGun/add_amount"] = 1 if is_shooting else 0
	handle_anim(delta)
	if is_moving:
		curr_anim = RUN
	else:
		curr_anim = IDLE

func handle_anim(delta):
	match curr_anim:
		IDLE:
			run_val = lerpf(run_val, 0, blend_speed*delta)
			update_animations(run_val)
		RUN:
			run_val = lerpf(run_val, 1, blend_speed*delta)
			update_animations(run_val)

func update_animations(run_value):
	anim_tree["parameters/IdleRunBlend/blend_amount"] = run_value

func _look_at_crosshair():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = ray_origin + camera.project_ray_normal(mouse_pos) * 500
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_dir)
	var space_state = get_world_3d().direct_space_state
	
	ray_query.collide_with_bodies = true
	
	var ray_result = space_state.intersect_ray(ray_query)
	
	if !ray_result.is_empty():
		look_at(ray_result.position)
		rotation.x = 0
		rotation.z = 0
		 
func get_ammo():
	return gun_script.get_ammo()
func _process(delta: float) -> void:
	if hp <= 0:
		visible = false
		print("morri")
		
func hit(damage:float, dir:Vector3):
	hp -= damage
