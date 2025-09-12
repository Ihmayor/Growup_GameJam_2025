class_name MaintainTextureUp extends AnimatedSprite2D

var original_position:Vector2

var rotate_offset

@export var offset_factor = 15

func _ready():
	original_position = position
	rotate_offset = Vector2(0, -offset_factor)
	position  = original_position + rotate_offset

func on_player_rotate():
	position = original_position
	rotation_degrees = fmod((0 - get_parent().rotation_degrees), 360)

	match(rotation_degrees):
		0.0:
			rotate_offset = Vector2(0,-offset_factor)
		90.0:
			rotate_offset = Vector2(offset_factor, 0)
		180.0:
			rotate_offset = Vector2(0, offset_factor)
		270.0:
			rotate_offset = Vector2(-offset_factor, 0)
		-90.0:
			rotate_offset = Vector2(-offset_factor, 0)
		-180.0:
			rotate_offset = Vector2(0, offset_factor)
		-270.0:
			rotate_offset = Vector2(offset_factor, 0)
	position = original_position + rotate_offset
	
