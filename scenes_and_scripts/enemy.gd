extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
var distance_to_stop_following:float = 9

var player:CharacterBody3D
const SPEED = 30
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	var level = get_tree().get_root().get_children()[1]
	player = level.find_child("Player")
	print("ENCOTNREI: ", player)
 
	navigation_agent_3d.path_desired_distance = distance_to_stop_following
	
func _physics_process(delta: float) -> void:
	target_position(player)
	
	if not navigation_agent_3d.is_navigation_finished():	 
		handle_movement(player)
		move_and_slide()
	else:
		print("I'm finished")

func handle_movement(target:CharacterBody3D) -> void:
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity
	var direction = (target.position -global_position).normalized() 
	velocity = direction * SPEED
	
func target_position(target:CharacterBody3D):
	navigation_agent_3d.target_position = target.position
