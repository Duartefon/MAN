extends Node3D

@export var enemy_type_array:Array[PackedScene]
@export var radius:float = 20
@export var enemies_to_spawn:int = 5
@export var parent_node:Node3D   
@export var enemy_manager_node:Node


func _spawn():
	for i in range(enemies_to_spawn):
		if enemy_type_array.is_empty():
			push_warning("Enemy type array is empty!")
			return
		
		var enemy_scene:PackedScene = enemy_type_array[randi() % enemy_type_array.size()]
		var enemy:Node3D = enemy_scene.instantiate()
		
		 
		if parent_node:
			parent_node.add_child(enemy)
		else:
			add_child(enemy) 
		
		 
		var spawn_point:Vector3 = global_position + Vector3(
			randf_range(-radius, radius),
			0.0,
			randf_range(-radius, radius)
		)
		
		enemy.global_position = spawn_point
		print("Spawned enemy at ", spawn_point)
		
		var manager = get_tree().get_first_node_in_group("enemy_manager")
		if manager:
			manager.register_enemy(enemy)

	print("Spawned all enemies")

func _ready() -> void:
	_spawn()

	if enemy_manager_node:
		enemy_manager_node.connect("all_enemies_defeated", Callable(self, "_on_all_enemies_defeated"))

func _on_all_enemies_defeated():
	print("Todos inimigos mortos! ")
	# aqui wtv o q acontece depois de todos mortos pode ser tipo abrir um portao
