extends RigidBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var player:CharacterBody3D
const SPEED = 5

var path
func _ready() -> void:
	var level = get_tree().get_root().get_children()[1]
	player = level.find_child("Player")
	print("ENCOTNREI: ", player)
 
func _process(delta: float) -> void:
	var next_location = navigation_agent_3d.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	linear_velocity = linear_velocity.move_toward(new_velocity, 0.25)
	target_position(player)
func target_position(target):
	navigation_agent_3d.target_position = target.position
