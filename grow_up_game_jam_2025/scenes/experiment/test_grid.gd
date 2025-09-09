extends Node2D

@export var level:LevelData

var grid_width = 5
var grid_height = 5

@onready var slot_scene = preload("res://slot.tscn");
@export var light_soil:AtlasTexture
@export var dark_soil:AtlasTexture

@export var light_planted_soil:AtlasTexture
@export var dark_planted_soil:AtlasTexture
var grid_size = 32

func _ready() -> void:
	generate_grid()
	
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
			
			if (i == 0 && j == 1):
				slot_instance.debug_active()
			
			alt = !alt
