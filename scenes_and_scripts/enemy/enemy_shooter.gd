extends Enemy

 
@onready var gun: Gun = $GunHolder
@onready var attack_wait_timer: Timer = $AttackWaitTimer

var can_attack:bool = false
 
	
func ready():
	attack_wait_timer.timeout.connect(_on_attack_wait_timeout)
	
func hit_player():
	
	print("shooting enemy")
	gun.enemy_shoot( )
	
	
func _on_attack_wait_timeout():
	can_attack = true
 
 
 
 
