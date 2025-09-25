extends RigidBody3D
class_name BulletData

@onready var life_timer: Timer = $LifeTime

var damage:float = 0
var life_time:float = 2.5

func set_damage(new_damage):
	damage = new_damage

func _ready() -> void:
	life_timer.timeout.connect(_on_life_timeout)
	life_timer.start(life_time)

func _on_life_timeout():
	queue_free()
	
