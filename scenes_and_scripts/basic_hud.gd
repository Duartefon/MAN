extends Node

@onready var health: Label = %Health
@onready var ammo_counter: RichTextLabel = $Control/Ammo_Counter/Ammo

const CROSSHAIR = preload("uid://dmh6meew0pmd5")
const AMMO_COUNTER = preload("uid://beuu87rbc6a1r")

 

func _ready() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR)
 
 
	SignalBus.update_weapon_ammo.connect(_on_update_weapon_ammo)
	SignalBus.update_player_health.connect(_on_update_weapon_ammo)
	
func _on_update_weapon_ammo(current_magazine_ammo, total_ammo):
	print("%d d%f" % [current_magazine_ammo, total_ammo])
	ammo_counter.text = "%d/%d" % [current_magazine_ammo, total_ammo]
	
func _on_update_player_health(current_health:float, total_health:float):
	print("%d d%f" % [current_health, total_health])
	health.text = "%d/%d" % [current_health, total_health]
