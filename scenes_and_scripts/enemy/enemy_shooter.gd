extends Enemy

 
@onready var gun: Gun = $GunHolder

func hit_player():
	print(	"shooting at the player")
	gun._on_shoot( )

 
func process():
	if !attack_in_progress:
		look_at(player.global_position)
 
