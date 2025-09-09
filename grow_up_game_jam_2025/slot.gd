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
	var is_valid_size
	var all_slots_valid
	var slots
	if (data is Draggable):
		slots = data.get_colliding_slots()
		var draggable_size = data.get_draggable_size()
		is_valid_size = slots.size() == draggable_size
		all_slots_valid = slots.all(func(s:Slot): return !s.isTaken || (s.isTaken && s.draggable_node == data ))
	is_valid =  all_slots_valid && is_valid_size && data is Draggable
	
	if is_valid:
		#Tell all neighbours this is now valid
		for s in slots:
			s.is_valid = true
	
	return is_valid

func add_plant_here(plant:Plant):
	$PlantTexture.texture = plant.first_image
	planted_plant = plant
	$SoilTexture.texture = soil_planted
	$Outline.visible = false

func remove_plant():
	$SoilTexture.texture = soil_unplanted
	$PlantTexture.texture = null
	planted_plant = null
	
func debug_active():
	self.isTaken = true
	self.isDebugging = true
	$SoilTexture.texture = soil_planted

func _physics_process(delta: float) -> void:
	if isTaken:
		$Outline.visible = false
		$Outline.modulate = Color.WHITE
		return
		
	if is_valid:
		$Outline.modulate = Color.GREEN
	else:
		$Outline.modulate = Color.RED
		

func _on_slot_area_area_entered(area: Area2D) -> void:
	$Outline.visible = true

func _on_slot_area_area_exited(area: Area2D) -> void:
	$Outline.visible = false
	$Outline.modulate = Color.WHITE
