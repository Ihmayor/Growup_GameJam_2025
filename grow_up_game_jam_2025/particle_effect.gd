class_name ParticlePlacement extends CPUParticles2D

func _on_garden_trigger_particle(location: Vector2) -> void:
	global_position = location
	emitting = true
