class_name GardenUI extends Control

@onready var slot_scene = preload("res://slot.tscn");
@export var main_theme : Theme
@export var grid_width = 5;
@export var grid_height = 5;

@export var light_soil:AtlasTexture
@export var dark_soil:AtlasTexture

@export var light_planted_soil:AtlasTexture
@export var dark_planted_soil:AtlasTexture


@export var test: Plant
@export var test2: Plant

var tromino = preload("res://scripts/new_drag/new_curve.tscn")
var tromino2 = preload("res://scripts/new_drag/new_line.tscn")


@export var all_plants: Array[Plant]

var grid_size: int = 32

signal lock_in_plant
signal trigger_particle(location:Vector2)

func _ready():
	generate_plants()
	generate_grid()

func generate_plants():
	var size_window : Vector2 = get_window().size
	var trominos = [tromino, tromino2]
	for i in range(8):
		var object:Draggable = trominos.pick_random().instantiate()
		add_child(object)
		var margin:int = 100
		object.global_position = Vector2(randf_range(margin, size_window.x-margin), randf_range(margin, size_window.y - margin))
		var new_plant = all_plants.pick_random()
		object.plant_data = new_plant
		object.set_plant()
		object.on_moving.connect(_on_pickup_event);
		object.on_locking.connect(_on_plant_event);
		object.on_particle_trigger.connect(_on_plant_particle)

func _on_pickup_event():
	%PickupSFX.play()

func _on_plant_event():
	%PlantSFX.play()
	lock_in_plant.emit()

func _on_plant_particle(position:Vector2):
	trigger_particle.emit(position)


func _process(delta: float):
	%GridContainer.global_position = ((get_window().size - Vector2i(grid_width * grid_size,grid_height * grid_size))/2)
	%GridContainer.global_position = round (%GridContainer.global_position / grid_size) * grid_size

func generate_grid() -> void: 
	%GridContainer.columns = grid_width
	var alt: bool = false

	for i in grid_height:
		for j in grid_width:
			var slot_instance:Slot = slot_scene.instantiate()
			slot_instance.name = "Slot"+str(i)+"_"+str(j)
			slot_instance.location = Vector2(j, i);
			if alt:
				slot_instance.soil_unplanted = light_soil
				slot_instance.soil_planted = light_planted_soil
			else:
				slot_instance.soil_unplanted = dark_soil
				slot_instance.soil_planted = dark_planted_soil
			%GridContainer.add_child(slot_instance)
			alt = !alt


func _on_node_2d_on_final_plant_placed(success: bool) -> void:
	visible = false
	if (success):
		#Clear old grid
		for slot in %GridContainer.get_children():
			%GridContainer.remove_child(slot)
			slot.queue_free()
		#Clear old plants
		for plant in get_tree().get_nodes_in_group("Plants"):
			plant.queue_free()
		
		generate_plants()
		generate_grid()
