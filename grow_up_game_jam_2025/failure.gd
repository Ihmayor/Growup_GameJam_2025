extends Control

func _on_node_2d_on_final_plant_placed(success: bool) -> void:
	visible = !success
	if (visible):
		$AudioStreamPlayer2D.play()
