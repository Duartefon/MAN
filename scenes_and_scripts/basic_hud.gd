extends Node
const CROSSHAIR = preload("uid://dmh6meew0pmd5")
const AMMO_COUNTER = preload("uid://beuu87rbc6a1r")
var _ammo_counter_text
var _health

func _ready() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR)
	_ammo_counter_text = $Control/Control/Ammo_Counter/Ammo
	_health = %Health
	
	
	
#func _process(_delta: float) -> void:
	#_ammo_counter_text.text = player.getAmmo()
	#_health.text = player.getHealth()
	
	
