extends Node2D


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes_and_scripts/level1.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes_and_scripts/level1.tscn")
		
