extends Camera3D

@export
var shake_strength : float
var max_shake_str : float
var shake_falloff : float

@onready var rnd_gen = RandomNumberGenerator.new()

@onready var player = $"../Player"       
@export var height: float = 50.0  
@export var offset: float = 5.0 
@export var follow_speed: float = 5.0 

func _ready() -> void:
	pass
	
func shake_camera():
	shake_strength = max_shake_str

func _process(delta: float) -> void:
	h_offset = rnd_gen.randf_range(-shake_strength, shake_strength)
	v_offset = rnd_gen.randf_range(-shake_strength, shake_strength)
	
	shake_strength = lerpf(shake_falloff, 0, delta*shake_falloff)
	follow_player(delta)

func follow_player(delta):
	if not player:
		return

	var target_pos = player.global_position + Vector3(0, height, offset)
	global_position = global_position.lerp(target_pos, follow_speed * delta)

	rotation.y = 0
	rotation.z = 0  # Optional: keeps camera fixed at its initial rotation
