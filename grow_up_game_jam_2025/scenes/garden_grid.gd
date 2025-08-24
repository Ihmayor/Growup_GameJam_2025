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


var grid_size: int = 32
func _ready():
	%GridContainer.columns = grid_width
	generate_grid()

func _process(delta: float):
	%GridContainer.global_position = ((get_window().size - Vector2i(grid_width * grid_size,grid_height * grid_size))/2)
	%GridContainer.global_position = round (%GridContainer.global_position / grid_size) * grid_size
	

func generate_grid() -> void: 
	var alt: bool = false
	for i in grid_height:
		for j in grid_width:
			var slot_instance:Slot = slot_scene.instantiate()
			slot_instance.index = Vector2(j, i);
		
			#if (i==2 && j ==2):
				#slot_instance.add_plant_here(test)
			#
			#if (i==2 && j ==3):
				#slot_instance.add_plant_here(test2)
			#
			#
			#if (i==0 && j == 3):
				#slot_instance.add_plant_here(test)
			
			
			if alt:
				slot_instance.soil_unplanted = light_soil
				slot_instance.soil_planted = light_planted_soil
			else:
				slot_instance.soil_unplanted = dark_soil
				slot_instance.soil_planted = dark_planted_soil
			print (slot_instance.name)
			%GridContainer.add_child(slot_instance)
			alt = !alt
func create_slot():
	pass
