class_name HUD extends Control

@export var player_data: PlayerData

func _process(delta: float) -> void:
	if (player_data != null):
		%ScoreLabel.text = "SCORE : " + str(player_data.running_total_score)
