class_name GameMusicManager extends Node

@export var level: LevelData

func play_music():
	get_child(0).play()
	for i in range(1, level.phase):
		get_child(i).play()
		print("play next phase")
	
func stop_music():
	for audio:AudioStreamPlayer2D in get_children():
		audio.stop()
	
