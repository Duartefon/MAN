extends Camera3D

@export var player: NodePath           
@export var mouse_sensitivity := 0.003
@export var distance := 5.0            # distância da camera atrás do player
@export var height := 2.0              # altura da câmera

@onready var player_node: CharacterBody3D = get_node(player)

var yaw := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		player_node.rotation.y = yaw

func _process(delta):
	var back_dir = player_node.transform.basis.z   
	global_transform.origin = player_node.global_transform.origin + back_dir * distance + Vector3(0, height, 0)
	
	look_at(player_node.global_transform.origin + Vector3(0, height/2, 0), Vector3.UP)
