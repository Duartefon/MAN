extends Node

@onready var player: CharacterBody3D = $"../Player"
@onready var ammo_counter: RichTextLabel = $Control/Ammo_Counter/Ammo
const CROSSHAIR = preload("uid://dmh6meew0pmd5")
const AMMO_COUNTER = preload("uid://beuu87rbc6a1r")
var _ammo_counter_text
var _health

func _ready() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR)
 
 
	SignalBus.update_weapon_ammo.connect(_on_update_weapon_ammo)
	
func _on_update_weapon_ammo(current_magazine_ammo, total_ammo):
	print("%d d%f" % [current_magazine_ammo, total_ammo])
	ammo_counter.text = "%d/%d" % [current_magazine_ammo, total_ammo]
