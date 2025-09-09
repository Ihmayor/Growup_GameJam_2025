class_name Slot extends Control

var is_mouse_entered:bool
var soil_unplanted: Texture2D
var soil_planted: Texture2D
var is_valid: bool = false
var planted_plant:Plant
var plant_node: DraggablePlant
var draggable_node : Draggable

var location: Vector2

@export var isTaken = false

@onready var takenBy = null
@onready var isDebugging:bool = false

@onready var area: Area2D = %SlotArea

var trowel_icon = load("res://Assets/UI/TrowelCursor.png")

func _ready():
	$SoilTexture.texture = soil_unplanted
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is Draggable:
		data.snap_to_place()
		
func _can_drop_data(at_position, data):
	var is_valid_size = true
	var all_slots_valid = true
	if (data is Draggable):
		var slots = data.get_colliding_slots()
		var draggable_size = data.get_draggable_size()
		is_valid_size = slots.size() == draggable_size
		all_slots_valid = slots.all(func(s:Slot): return !s.isTaken || (s.isTaken && s.draggable_node == data ))
	return all_slots_valid && is_valid_size && data is Draggable

func add_plant_here(plant:Plant):
	$PlantTexture.texture = plant.first_image
	planted_plant = plant
	$SoilTexture.texture = soil_planted

func remove_plant():
	$SoilTexture.texture = soil_unplanted
	$PlantTexture.texture = null
	planted_plant = null
	
func debug_active():
	print("set once?")
	self.isTaken = true
	self.isDebugging = true
	print(self.isTaken)
	$SoilTexture.texture = soil_planted
