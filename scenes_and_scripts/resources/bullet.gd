extends RigidBody3D
class_name Bullet

@onready var life_timer: Timer = $LifeTime
@onready var explosion: ParticleSystemManager = $Explosion
 


const COLLISION_TO_IGNORE = 5
var damage:float = 0
var life_time:float = 2.5
var root_level:Node3D

func set_damage(new_damage):
	damage = new_damage
func get_damage():
	return damage
func _ready() -> void:
	life_timer.timeout.connect(_on_life_timeout)
	life_timer.start(life_time)
	root_level = get_tree().root.get_children()[1]
	

func _on_life_timeout():
	queue_free()
	


 

#compliquei uma beca mas funciona
func _on_area_3d_body_entered(body: Node3D) -> void:
 
	if self.is_in_group("BulletEnemy"):
		pass#collision_layer = 
	if body != self:
		if body.is_in_group("Enemy"):
			body.apply_damage(damage)
		elif body.is_in_group("Player"):
			body.hit(damage, global_position)
		else:
			explosion.global_position = global_position
			explosion.reparent(root_level)
			explosion.play()

		queue_free()

		 
			
		
		
		 
