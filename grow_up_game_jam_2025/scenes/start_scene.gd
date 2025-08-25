extends Node2D

func start_game():
	%Audio.play()
	%Audio.finished.connect(_on_done)

func _on_done():
	get_tree().change_scene_to_file("res://main_garden.tscn")
	
