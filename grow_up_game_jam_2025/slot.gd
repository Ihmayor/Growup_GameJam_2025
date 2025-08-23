class_name Slot extends TextureButton

var is_mouse_entered:bool

func _process(delta:float)-> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		
		print(event)
	if event is InputEventMouseMotion:	
		pass 
