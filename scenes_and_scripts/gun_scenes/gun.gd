extends Node3D
class_name Gun

@export var shoot_type:GunType
@onready var ray_cast_3d: RayCast3D = $glock/RayCast3D
@onready var camera: Camera3D = $"../../../../../../../Camera3D"
@onready var gun_barrel: Node3D = $glock/GunBarrel
@onready var reload_timer: Timer = $ReloadTimer
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var gun_data: GunData
enum GunType {PROJECTILE, HITSCAN}

const BULLET_SPEED:float = 14
const BULLET = preload("res://scenes_and_scripts/gun_scenes/bullet.tscn")
# se tiver tempo 90%  destas variaveis deixam de existir neste script e passa-se a usar diretamente o gun_data.variavel 
var bullet_damage:float = 50 
var magazine_ammo:int = 10
var current_magazine_ammo:int = magazine_ammo 
var total_ammo:int = 50
var fire_rate: float = 0.5
var reload_duration: float = 0.45
var can_shoot:bool = true
var can_reload:bool = true

signal weapon_reloaded(current_magazine_ammo, total_ammo)
	
func _ready() -> void:
	fire_rate_timer.timeout.connect(_on_fire_rate_timeout)
	reload_timer.timeout.connect(_on_reload_timeout)
	
	bullet_damage = gun_data.bullet_damage 
	magazine_ammo = gun_data.magazine_ammo
	total_ammo = gun_data.total_ammo
	fire_rate = gun_data.fire_rate
	reload_duration = gun_data.reload_duration
	add_child(gun_data.MODEL.instantiate())
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire_gun") and current_magazine_ammo > 0 and can_shoot and can_reload:
		_on_shoot()
		audio_stream_player_3d.stream = gun_data.SHOOT_SOUND
		audio_stream_player_3d.play()
		current_magazine_ammo -= 1
		can_shoot = false
		fire_rate_timer.start(fire_rate)
		SignalBus.update_weapon_ammo.emit(current_magazine_ammo, total_ammo)
		
	if Input.is_action_just_pressed("reload_gun") and can_reload:
		
		_on_reload()
		audio_stream_player_3d.stream = gun_data.RELOAD_SOUND
		audio_stream_player_3d.play()
		can_reload = false
		
func _on_fire_rate_timeout():
	can_shoot = true

func _on_shoot() -> void:
	if shoot_type == GunType.PROJECTILE:
		var bullet_instance:BulletData = BULLET.instantiate()
		bullet_instance.set_damage(bullet_damage)
		bullet_instance.position = ray_cast_3d.global_position
 
		var node_root := get_tree().get_root().get_children()[0]
		node_root.add_child(bullet_instance)
 		
		bullet_instance.apply_impulse(global_transform.basis.z * BULLET_SPEED)
		
	
func _on_reload() -> void:
	var ammo_to_reload = magazine_ammo - current_magazine_ammo 
	if total_ammo - ammo_to_reload >= 0 and can_reload:
		current_magazine_ammo = magazine_ammo
		total_ammo -= ammo_to_reload
		can_reload = false
		reload_timer.start(reload_duration)
		
func _on_reload_timeout() -> void:
	can_reload = true	
	SignalBus.update_weapon_ammo.emit(current_magazine_ammo, total_ammo)
	
func get_ammo() -> Vector2:
	return Vector2(current_magazine_ammo, total_ammo)

		
