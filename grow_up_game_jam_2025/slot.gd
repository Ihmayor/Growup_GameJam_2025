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
	if (mouse_entered.get_connections().size() == 0):
		mouse_entered.connect(_mouse_entered)

	if (mouse_exited.get_connections().size() == 0):
		mouse_exited.connect(_mouse_exited)
		
	$SoilTexture.texture = soil_unplanted
	

func _physics_process(delta: float):
	pass
	#var collisions = %SlotArea.get_overlapping_areas()
	#var found_plant:bool = false
	#for collision in collisions:
		#var plant = collision.get_parent() as DraggablePlant
		#
		#if !plant && collision.get_parent() is PlantScript:
			#plant = collision.get_parent().get_parent().get_parent() as DraggablePlant			
		#
		#if plant:
			#found_plant = true
			#plant_node = plant
			##isTaken = true
			#add_plant_here(plant.plant_data)
			#$SoilTexture.texture = soil_planted
		#else:
			#print("not a plant but colliding???")
			#print(collision.name)
			
	#if !found_plant:
		#planted_plant = null
		#plant_node = null
		##isTaken = false
		#$SoilTexture.texture = soil_unplanted
	
func _mouse_entered():
	$Outline.visible = true
	if !isTaken:
		$Outline.modulate = Color.GREEN
	else:
		$Outline.modulate = Color.RED

func _mouse_exited():
	$Outline.visible = false
	$Outline.modulate = Color.GREEN

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is Draggable:
		data.snap_to_place()

func _can_drop_data(at_position, data):
	print("is over")
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

	
func debug_active():
	print("set once?")
	self.isTaken = true
	self.isDebugging = true
	print(self.isTaken)
	$SoilTexture.texture = soil_planted
