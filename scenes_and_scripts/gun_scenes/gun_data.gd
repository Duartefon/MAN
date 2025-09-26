extends Resource
class_name GunData

@export var bullet_damage:float 
@export var magazine_ammo:int = 10
@export var  total_ammo:int = 50
@export var fire_rate: float = 0.5
@export var reload_duration: float = 0.45

@export var MODEL: PackedScene 
@export var SHOOT_SOUND: Resource
@export var RELOAD_SOUND: Resource
@export var EMPTY_SHOOT_SOUND: Resource
