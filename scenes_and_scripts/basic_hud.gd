extends Node

@onready var health: Label = %Health
@onready var ammo_counter: RichTextLabel = $Control/Ammo_Counter/Ammo
@onready var facecam = $Control/Control/healthy

var player_health: float
var player: CharacterBody3D
const CROSSHAIR = preload("uid://dmh6meew0pmd5")
const AMMO_COUNTER = preload("uid://beuu87rbc6a1r")
 

func _ready() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR)
	facecam.play("healthy");
	SignalBus.update_weapon_ammo.connect(_on_update_weapon_ammo)
	SignalBus.update_player_health.connect(_on_update_weapon_ammo)
	
func _process(delta):
	var level = get_tree().get_current_scene()
	if level: player = find_player(level)
	player_health = player.get_hp()
	
	update_facecam()
	
		
func update_facecam():
	if player_health >= 100:
		facecam.play("healthy");
	elif player_health<100 and player_health>50:
		facecam.play("damaged");
	else:
		facecam.play("super_damaged");
			
	
func _on_update_weapon_ammo(current_magazine_ammo, total_ammo):
	#print("%d %d" % [current_magazine_ammo, total_ammo])
	ammo_counter.text = "%d/%d" % [current_magazine_ammo, total_ammo]
	
func _on_update_player_health(current_health:float, total_health:float):
	#print("%d %d" % [current_health, total_health])
	health.text = "%d/%d" % [current_health, total_health]
	
func find_player(node: Node) -> CharacterBody3D:
	for child in node.get_children():
		if child.name == "Player":
			return child as CharacterBody3D
		if child.has_method("get_children"):
			var found = find_player(child)
			if found:
				return found
	return null
