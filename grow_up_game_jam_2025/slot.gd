class_name Slot extends Control

var is_mouse_entered:bool
var soil_unplanted: Texture2D
var is_valid: bool = false
var planted_plant:Plant
var index: Vector2

@onready var area: Area2D = %SlotArea

func _ready():
	if (mouse_entered.get_connections().size() > 0):
		mouse_entered.connect(_mouse_entered)

	if (mouse_exited.get_connections().size() > 0):
		mouse_exited.connect(_mouse_exited)
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)
	
	
func _on_area_entered(entered_entity: Area2D):
	if (entered_entity.get_parent() is DraggablePlant):
		planted_plant = entered_entity.get_parent().plant_data
		add_plant_here(planted_plant)

func _on_area_exited(entered_entity: Area2D):
	if (entered_entity.get_parent() is DraggablePlant):
		planted_plant = null
		$PlantTexture.texture = null
	#(entered_entity.get_parent() is DraggablePlant)
	pass
	
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
