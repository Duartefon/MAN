extends Node3D
class_name Bullet

@onready var life_timer: Timer = $BulletBody/LifeTime
@onready var explosion: ParticleSystemManager = $Explosion
@onready var bullet_body: RigidBody3D = $BulletBody


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
 
	if body != bullet_body:
		explosion.global_position = bullet_body.global_position
		explosion.play()	
		bullet_body.queue_free()
		
		
		 
