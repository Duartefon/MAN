extends Node3D
class_name Gun

@export var shoot_type:GunType

@onready var reload_timer: Timer = $ReloadTimer
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var current_weapon: Node = $CurrentWeapon
@onready var inventory: Node3D = $Inventory

@export var me_enemy_gun:bool = false
@export var gun_data: GunData
enum GunType {PROJECTILE, HITSCAN}

var BULLET_SPEED:float = 50
const BULLET = preload("uid://k3w57e61h4bq")
# se tiver tempo 90%  destas variaveis deixam de existir neste script e passa-se a usar diretamente o gun_data.variavel 
var bullet_damage:float = 50 
var magazine_ammo:int = 10
var current_magazine_ammo:int = magazine_ammo 
var total_ammo:int = 50
var fire_rate: float = 0.5
var reload_duration: float = 0.45
var can_shoot:bool = true
var can_reload:bool = true
var projectile_container:Node3D
var current_weapon_instance: Node3D = null

@export var current_weapon_data: GunData
signal weapon_reloaded(current_magazine_ammo, total_ammo)

func _ready() -> void:
	fire_rate_timer.timeout.connect(_on_fire_rate_timeout)
	reload_timer.timeout.connect(_on_reload_timeout)

	projectile_container = get_tree().root.get_node("Main/ProjectileContainer") # safer than index lookup
	equip_weapon(gun_data)  # load the starting weapon
func _process(delta: float) -> void:
	if me_enemy_gun:
		return

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
	if Input.is_action_just_pressed("weapon1"):
		switch_weapon(preload("res://scenes_and_scripts/gun_scenes/blaster.tres"))


	elif Input.is_action_just_pressed("weapon2"):
		switch_weapon(preload("res://scenes_and_scripts/resources/revolver_data.tres"))

func _on_fire_rate_timeout():
	can_shoot = true

func _on_shoot() -> void:
	if shoot_type == GunType.PROJECTILE:
		var bullet_instance: Bullet = BULLET.instantiate()
		bullet_instance.set_damage(bullet_damage)
		bullet_instance.global_position = current_weapon.get_child(0).get_raycast().global_position
		bullet_instance.set_velocity(global_transform.basis.z * BULLET_SPEED)
		current_weapon.get_child(0).play()
		projectile_container.add_child(bullet_instance)
		
func enemy_shoot():#esta a faltarme algum detalhe pq o inimigo dispara ao contrario, 
	#n consegui resolver bonito ent meti fitacola fds
	var bullet_instance:Bullet = BULLET.instantiate()
	bullet_instance.set_damage(bullet_damage)
	bullet_instance.global_position = 	current_weapon.get_child(0).get_raycast().global_position
	bullet_instance.set_velocity(-global_transform.basis.z * BULLET_SPEED)
	
	
	current_weapon.get_child(0).play() 
	projectile_container.add_child(bullet_instance)
 
	
func _on_reload() -> void:
	var ammo_to_reload = magazine_ammo - current_magazine_ammo 
	if total_ammo - ammo_to_reload >= 0 and can_reload:
		current_magazine_ammo = magazine_ammo
		total_ammo -= ammo_to_reload
		can_reload = false
		reload_timer.start(reload_duration)
		SignalBus.update_reload.emit(reload_duration)
		
		
func _on_reload_timeout() -> void:
	can_reload = true	
	SignalBus.update_weapon_ammo.emit(current_magazine_ammo, total_ammo)
	
func get_ammo() -> Vector2:
	return Vector2(current_magazine_ammo, total_ammo)

func equip_weapon(gun_data: GunData) -> void:
	# Remove old weapon model if it exists
	if current_weapon_instance:
		current_weapon_instance.queue_free()
		current_weapon_instance = null
	
	# Store the new gun data
	current_weapon_data = gun_data
	
	# Instance the weapon model
	if current_weapon_data and current_weapon_data.MODEL:
		current_weapon_instance = current_weapon_data.MODEL.instantiate()
		add_child(current_weapon_instance)
		current_weapon_instance.owner = self.get_tree().edited_scene_root  # so it saves in editor, optional
	
	# Here you can also preload sounds or assign other values
	# Example: connect sounds to an AudioStreamPlayer if you want

func switch_weapon(new_gun_data: GunData) -> void:
	equip_weapon(new_gun_data)
