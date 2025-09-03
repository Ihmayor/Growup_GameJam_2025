class_name Slot extends Control

var is_mouse_entered:bool
var soil_unplanted: Texture2D
var soil_planted: Texture2D
var is_valid: bool = false
var planted_plant:Plant
var index: Vector2

@export var isTaken = false

var takenBy = null

@onready var area: Area2D = %SlotArea

var trowel_icon = load("res://Assets/UI/TrowelCursor.png")

func _ready():
	if (mouse_entered.get_connections().size() == 0):
		mouse_entered.connect(_mouse_entered)

	if (mouse_exited.get_connections().size() == 0):
		mouse_exited.connect(_mouse_exited)
		
	$SoilTexture.texture = soil_unplanted
	

func _physics_process(delta: float):
	var collisions = %SlotArea.get_overlapping_areas()
	var found_plant:bool = false
	for collision in collisions:
		var plant = collision.get_parent() as DraggablePlant
		if plant:
			found_plant = true
			add_plant_here(plant.plant_data)
			$SoilTexture.texture = soil_planted
	if !found_plant:
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
	$SoilTexture.texture = soil_planted
