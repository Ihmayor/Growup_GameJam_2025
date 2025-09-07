extends Control


func _on_node_2d_on_final_plant_placed(success: bool) -> void:
	visible = success
	


func _on_button_pressed() -> void:
	visible = false
