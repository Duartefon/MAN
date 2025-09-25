extends Area3D
class_name hurtbox


var health := 100.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node3D):
	if body.is_in_group("Bullets"):
		health -= body.damage
		if health <= 0:
			get_parent().queue_free()
	
	
