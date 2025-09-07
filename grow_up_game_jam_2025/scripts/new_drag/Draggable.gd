class_name Draggable extends Control

func _get_drag_data(at_position):
	var preview_texture:Control = $".".duplicate()
	preview_texture.modulate.a = 0.4
	preview_texture.name = "test"
	var c = Control.new()
	c.add_child(preview_texture)
	preview_texture.position = Vector2.ZERO - at_position
	
	set_drag_preview(c)
	return self

func snap_to_place(position:Vector2):
	global_position = position
