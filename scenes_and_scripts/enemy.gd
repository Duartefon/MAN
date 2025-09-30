extends CharacterBody3D
class_name Enemy

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree = $PlantModel/AnimationTree
@onready var anim_player: AnimationPlayer = $PlantModel/AnimationPlayer

@export var body: MeshInstance3D
@export var legs: MeshInstance3D
@export var attack_range: float = 10.0

const SPEED: float = 3
const DAMAGE: float = 25
const ATTACK_ANIMATION_OFFSET: float = 0.35
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp = 100

# States
enum State { IDLE, CHASE, ATTACK }
var state: State = State.IDLE
var state_time: float = 0.0

# Animation helpers
var walk_val: float = 0.0
var blend_speed: float = 10.0

# Player reference
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

	body.material_override = body.mesh.surface_get_material(0).duplicate()
	legs.material_override = legs.mesh.surface_get_material(0).duplicate()

	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	state_time += delta
	match state:
		State.IDLE:
			update_idle(delta)
		State.CHASE:
			update_chase(delta)
		State.ATTACK:
			update_attack(delta)
	
	update_animation(delta)

# ------------------
# State Management
# ------------------
func change_state(new_state: State) -> void:
	if state == new_state:
		return
	state = new_state
	state_time = 0.0
	match state:
		State.IDLE:
			walk_val = 0.0
		State.CHASE:
			pass
		State.ATTACK:
			anim_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

# ------------------
# State Updates
# ------------------
func update_idle(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	if distance > attack_range:
		change_state(State.CHASE)
	elif distance <= attack_range:
		change_state(State.ATTACK)

func update_chase(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		change_state(State.ATTACK)
		return
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta
	
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
	look_at(player.global_position, Vector3.UP)

func update_attack(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	move_and_slide()
	look_at(player.global_position, Vector3.UP)

	var attack_duration = anim_player.get_animation("Attack").length
	var hit_time = ATTACK_ANIMATION_OFFSET
	
	# Deal damage at the right moment
	if state_time >= hit_time and state_time - delta < hit_time:
		hit_player()

	# Return to idle once attack animation is done
	if state_time >= attack_duration:
		change_state(State.IDLE)

# ------------------
# Animations
# ------------------
func update_animation(delta: float) -> void:
	match state:
		State.IDLE:
			walk_val = lerpf(walk_val, 0.0, blend_speed * delta)
		State.CHASE:
			walk_val = lerpf(walk_val, 1.0, blend_speed * delta)
		State.ATTACK:
			walk_val = 0.0
	anim_tree["parameters/IdleRunBlend/blend_amount"] = walk_val

# ------------------
# Combat
# ------------------
func hit_player():
	if target_in_attack_range() and player:
		var dir = global_position.direction_to(player.global_position)
		player.hit(DAMAGE, dir)

func target_in_attack_range() -> bool:
	return player and global_position.distance_to(player.global_position) < attack_range

func apply_damage(damage):
	hp -= damage
	flash_material()
	if hp <= 0:
		queue_free()
	else:
		$DamageIndicator.create_indicator_label(damage)

func flash_material():
	var mat_body = body.material_override
	if mat_body == null:
		mat_body = body.mesh.surface_get_material(0).duplicate()
		body.material_override = mat_body

	var mat_legs = legs.material_override
	if mat_legs == null:
		mat_legs = legs.mesh.surface_get_material(0).duplicate()
		legs.material_override = mat_legs

	mat_body.emission_enabled = true
	mat_body.emission = Color(1,1,1)
	mat_legs.emission_enabled = true
	mat_legs.emission = Color(1,1,1)

	var tween = get_tree().create_tween()
	tween.tween_property(mat_body, "emission", Color(0,0,0), 0.2)
	tween.tween_property(mat_legs, "emission", Color(0,0,0), 0.2)
