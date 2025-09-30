extends Area3D
class_name Bullet

@onready var life_timer: Timer = $LifeTime
@onready var explosion: ParticleSystemManager = $Explosion

var damage: float = 0
var life_time: float = 2.5
var root_level: Node3D
var velocity: Vector3 = Vector3.ZERO

func set_damage(new_damage): 
	damage = new_damage

func get_damage(): 
	return damage

func _ready() -> void:
	life_timer.timeout.connect(_on_life_timeout)
	life_timer.start(life_time)
	root_level = get_tree().root.get_children()[1]

	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func _on_life_timeout():
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body == self:
		return
	
	if body.is_in_group("Enemy"):
		body.apply_damage(damage)
	elif body.is_in_group("Player"):
		body.hit(damage, body.global_position-global_position)
	else:
		explosion.global_position = global_position
		explosion.reparent(root_level)
		explosion.play()

	queue_free()

# Let the gun set this
func set_velocity(new_velocity: Vector3) -> void:
	velocity = new_velocity
