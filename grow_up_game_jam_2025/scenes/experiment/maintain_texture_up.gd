class_name MaintainTextureUp extends TextureRect

func rotate():
	rotation_degrees = fmod((0 - get_parent().rotation_degrees), 360)
