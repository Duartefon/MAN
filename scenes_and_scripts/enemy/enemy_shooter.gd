extends Enemy

 
@onready var gun: Gun = $GunHolder
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var can_attack:bool = false
 
	
func ready():
	attack_wait_timer.timeout.connect(_on_attack_wait_timeout)
	
func hit_player():
	
	print("shooting enemy")
	gun.enemy_shoot( )
	
	
func _on_attack_wait_timeout():
	can_attack = true
 

func random_pitch():
	audio_stream_player_3d.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player_3d.play()
 
