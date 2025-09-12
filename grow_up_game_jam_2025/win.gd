extends Control

func _on_button_pressed() -> void:
	OS.shell_open("https://vancouverfoodnetworks.com") 

func _on_game_music_on_game_finish() -> void:
	visible = true
