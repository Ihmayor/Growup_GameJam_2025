extends Control

func _physics_process(delta: float) -> void:
	pass
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is Draggable:
		data.temp_spot(global_position + Vector2(32,32))
		
func _can_drop_data(at_position, data):
	print("is over???")
	return data is Draggable
