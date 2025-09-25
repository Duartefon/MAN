extends Node3D
@export var shoot_type:GunType
@onready var ray_cast_3d: RayCast3D = $glock/RayCast3D
@onready var camera: Camera3D = $"../../../../../../../Camera3D"
@onready var gun_barrel: Node3D = $glock/GunBarrel

enum GunType {PROJECTILE, HITSCAN}

var bullet_damage:float
var ammo_magazine:float
var total_ammo:float
const BULLET_SPEED:float = 14
const BULLET = preload("res://scenes_and_scripts/gun_scenes/bullet.tscn")
 

 

 
func _on_reload() -> void:
	pass
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire_gun"):
		print("pressionado")
		_on_shoot()
 


func _on_shoot() -> void:
	print("_on_shoot called")
	if shoot_type == GunType.PROJECTILE:
		print("firing my weapon!!")
		var bullet_instance:RigidBody3D = BULLET.instantiate()
		bullet_instance.position = ray_cast_3d.global_position
 
		var node_root := get_tree().get_root().get_children()[0]
		node_root.add_child(bullet_instance)
 		
		bullet_instance.apply_impulse(global_transform.basis.z * BULLET_SPEED)
		 
		
