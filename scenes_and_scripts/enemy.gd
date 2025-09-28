extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree = $PlantModel/AnimationTree

const SPEED: float = 3
const ATTACK_RANGE: float = 10.0
const DAMAGE: float = 25
const ATTACK_ANIMATION_OFFSET: float = 0.35#when the enemy actually attacks
var distance_to_stop_following: float = 9
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp = 100
# ANIM
enum {IDLE, WALK, ATTACK}
var curr_anim = IDLE
var walk_val = 0.0
var blend_speed = 10.0
var attack_in_progress = false

var player: CharacterBody3D

func find_player(node: Node) -> CharacterBody3D:
	for child in node.get_children():
		if child.name == "Player":
			return child as CharacterBody3D
		if child.has_method("get_children"):
			var found = find_player(child)
			if found:
				return found
	return null

func _ready() -> void:
	var level = get_tree().get_current_scene()
	if level:
		player = find_player(level)
		if player:
			print("Found player: ", player)
		else:
			print("Player not found in scene!")



func _physics_process(delta: float) -> void:
	if not player:
		return
	
	update_target_position()
	handle_movement(delta)
	handle_anim(delta)

func update_target_position():
	navigation_agent_3d.target_position = player.global_position

func handle_movement(delta: float):
	if attack_in_progress:
		velocity.x = 0
		velocity.z = 0
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance > ATTACK_RANGE:
		curr_anim = WALK
		move_towards_player(delta)
	else:
		if not attack_in_progress:
			start_attack()

func move_towards_player(delta: float):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta
	
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
	look_at(player.global_position, Vector3.UP)

func start_attack():
	attack_in_progress = true
	curr_anim = ATTACK
	anim_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	
	
	var attack_duration = $PlantModel/AnimationPlayer.get_animation("Attack").length - ATTACK_ANIMATION_OFFSET
 
	await get_tree().create_timer(attack_duration).timeout
	
	attack_in_progress = false
 
	curr_anim = IDLE

func handle_anim(delta: float):
	match curr_anim:
		IDLE:
			walk_val = lerpf(walk_val, 0.0, blend_speed * delta)
		WALK:
			walk_val = lerpf(walk_val, 1.0, blend_speed * delta)
		ATTACK:
			walk_val = 0.0
	
	anim_tree["parameters/IdleRunBlend/blend_amount"] = walk_val

func is_moving() -> bool:
	return velocity.x != 0 or velocity.z != 0

func hit_player():
	if target_in_attack_range() and player:
		var dir = global_position.direction_to(player.global_position)
		player.hit(DAMAGE, dir)

func target_in_attack_range() -> bool:
	return player and global_position.distance_to(player.global_position) < ATTACK_RANGE

#TODO: fazer o damage indicator mais funcional e n depender do inimigo estar vivo
func apply_damage(damage):
	hp -= damage

	
	if hp <= 0:
		queue_free()
	else: 
		$DamageIndicator.create_indicator_label(damage)
