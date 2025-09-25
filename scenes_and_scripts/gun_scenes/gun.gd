extends Node3D
@export var shoot_type:GunType
@onready var ray_cast_3d: RayCast3D = $glock/RayCast3D
@onready var camera: Camera3D = $"../../../../../../../Camera3D"
@onready var gun_barrel: Node3D = $glock/GunBarrel
@onready var reload_timer: Timer = $ReloadTimer
@onready var fire_rate_timer: Timer = $FireRateTimer

enum GunType {PROJECTILE, HITSCAN}

const BULLET_SPEED:float = 14
const BULLET = preload("res://scenes_and_scripts/gun_scenes/bullet.tscn")

var bullet_damage:float = 50 
var magazine_ammo:float = 10
var current_magazine_ammo:float = magazine_ammo 
var total_ammo:float = 50
var fire_rate: float = 0.5
var reload_duration: float = 0.45
var can_shoot:bool = true
var can_reload:bool = true

 	


func _ready() -> void:
	fire_rate_timer.timeout.connect(_on_fire_rate_timeout)
	reload_timer.timeout.connect(_on_reload_timeout)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire_gun") and current_magazine_ammo > 0 and can_shoot:
		_on_shoot()
		current_magazine_ammo -= 1
		can_shoot = false
		fire_rate_timer.start(fire_rate)
	if Input.is_action_just_pressed("reload_gun") and can_reload:
		_on_reload()
		can_reload = false
		
func _on_fire_rate_timeout():
	print("PODES DISPARAR")
	can_shoot = true


func _on_shoot() -> void:
	print("_on_shoot called")
	if shoot_type == GunType.PROJECTILE:
		print("firing my weapon!!")
		var bullet_instance:RigidBody3D = BULLET.instantiate()
		bullet_instance.position = ray_cast_3d.global_position
 
		var node_root := get_tree().get_root().get_children()[0]
		node_root.add_child(bullet_instance)
 		
		bullet_instance.apply_impulse(global_transform.basis.z * BULLET_SPEED)
		
		
 
func _on_reload() -> void:
	print("RELOADING ARGH")
	var ammo_to_reload = magazine_ammo - current_magazine_ammo 
	if total_ammo - ammo_to_reload >= 0 and can_reload:
		current_magazine_ammo = magazine_ammo
		total_ammo -= ammo_to_reload
		can_reload = false
		reload_timer.start(reload_duration)
		
func _on_reload_timeout() -> void:
	can_reload = true	
	
 
	

		
