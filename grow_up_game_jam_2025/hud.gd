class_name HUD extends Control

@export var player_data: PlayerData
@export var level_data :LevelData

func _process(delta: float) -> void:
	if (player_data != null && level_data != null):
		%ScoreLabel.text = "OUTPUT : " + str(player_data.running_total_score) + "/" + str(level_data.quota)
	else:
		print('yeah no')
