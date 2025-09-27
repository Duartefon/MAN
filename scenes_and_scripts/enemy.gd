extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
const SPEED:float = 30
const ATTACK_RANGE:float = 10.0
const DAMAGE:float = 25
var distance_to_stop_following:float = 9
var player:CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state_machine
var anim_tree: AnimationTree

func _ready() -> void:
	var level = get_tree().get_root().get_children()[1]
	player = level.find_child("Player")
	print("ENCOTNREI: ", player) 
	navigation_agent_3d.path_desired_distance = distance_to_stop_following
	
	anim_tree = get_child(-1).get_child(-1)
	state_machine = anim_tree.get("parameters/playback")
	
func _physics_process(delta: float) -> void:
	target_position(player)
	

 
		
	match state_machine.get_current_node():
		"Idle":
			anim_tree.set("parameters/conditions/Walk", true)
		"Walk":
			if not navigation_agent_3d.is_navigation_finished():	 
				
				handle_movement(player)
				look_at(navigation_agent_3d.get_next_path_position())
				move_and_slide()
				anim_tree.set("parameters/conditions/Attack", target_in_attack_range())
		"Attack":
				anim_tree.set("parameters/conditions/Walk", !target_in_attack_range())
				print("In range?", !target_in_attack_range())
				look_at(player.global_position)
				
			
		"Death":
			pass
		"Hit":
			pass
func hit_player():
	if target_in_attack_range():
		var dir = global_position.direction_to(player.global_position)		
		player.hit(DAMAGE, dir)
func handle_movement(target:CharacterBody3D) -> void:
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity
	var direction = (target.position -global_position).normalized() 
	velocity = direction * SPEED
	
func target_position(target:CharacterBody3D):
	navigation_agent_3d.target_position = target.position

func target_in_attack_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
