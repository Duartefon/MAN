extends Node3D
class_name player
@onready var gun_holder: Node = $GunHolder
@onready var anim_tree = $AnimationPlayer/AnimationTree



func get_ammo():
	return "OLA"
	
	
