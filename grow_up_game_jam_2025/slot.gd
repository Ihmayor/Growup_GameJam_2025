class_name Slot extends Control

var is_mouse_entered:bool
var soil_unplanted: Texture2D
var is_valid: bool = false
var planted_plant:Plant
var index: Vector2

func _ready():
	pass
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	
func _process(delta:float):
	$SoilTexture.texture = soil_unplanted
	
func _mouse_entered():
	$Outline.visible = true
	$Outline.modulate = Color.GREEN

func _mouse_exited():
	$Outline.visible = false
	$Outline.modulate = Color.GREEN

func add_plant_here(plant:Plant):
	$PlantTexture.texture = plant.first_image
	planted_plant = plant
	#$SoilTexture.modulate = Color.CHOCOLATE TODO CHANGE THIS TO NEW PLANTED TEXTURE
