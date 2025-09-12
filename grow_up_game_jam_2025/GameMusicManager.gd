class_name GameMusicManager extends Node

@export var level: LevelData
signal on_game_finish

func play_music():
	stop_music()
	if level.phase >= get_children().size():
		on_game_finish.emit()
		return
	get_child(0).play()
	for i in range(1, level.phase):
		get_child(i).play()
		print("play next phase")
	
func stop_music():
	for audio:AudioStreamPlayer2D in get_children():
		audio.stop()
	
