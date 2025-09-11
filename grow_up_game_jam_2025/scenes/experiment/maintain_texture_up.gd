class_name MaintainTextureUp extends TextureRect

var original_position:Vector2

var rotate_offset

func _ready():
	original_position = position
	rotate_offset = Vector2(0, -10)

func rotate():
	position = original_position
	rotation_degrees = fmod((0 - get_parent().rotation_degrees), 360)

	match(rotation_degrees):
		0.0:
			rotate_offset = Vector2(0,-10)
		90.0:
			rotate_offset = Vector2(10, 0)
		180.0:
			rotate_offset = Vector2(0, 10)
		270.0:
			rotate_offset = Vector2(-10, 0)
		-90.0:
			rotate_offset = Vector2(-10, 0)
		-180.0:
			rotate_offset = Vector2(0, 10)
		-270.0:
			rotate_offset = Vector2(10, 0)
	position = original_position + rotate_offset
	
