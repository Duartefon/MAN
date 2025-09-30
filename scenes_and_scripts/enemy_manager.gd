extends Node3D
class_name EnemyManager

signal all_enemies_defeated

var total_enemies:int = 0
var alive_enemies:int = 0

func register_enemy(enemy: Node3D) -> void:
	total_enemies += 1
	alive_enemies += 1

	enemy.connect("tree_exited", Callable(self, "_on_enemy_died"))

func _on_enemy_died() -> void:
	alive_enemies -= 1
	if alive_enemies <= 0:
		print("mataste todos as plantas q spawnaram")
		emit_signal("all_enemies_defeated")
