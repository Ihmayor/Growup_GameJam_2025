extends Node2D

func start_game():
	start_ftue();

func start_ftue():
	$CanvasLayer/CenterContainer.visible = false
	$CanvasLayer/FTUE.visible = true
	
func end_ftue():
	%Audio.play()
	%Audio.finished.connect(_on_done)

func _on_done():
	get_tree().change_scene_to_file("res://main_garden.tscn")

func _on_ftue_button_pressed():
	end_ftue()
