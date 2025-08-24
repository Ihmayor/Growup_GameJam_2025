class_name GardenUI extends Control

@onready var slot_scene = preload("res://slot.tscn");
@export var main_theme : Theme
@export var grid_width = 5;
@export var grid_height = 5;

@export var light_soil:AtlasTexture
@export var dark_soil:AtlasTexture

@export var test_plant:Plant
func _ready() -> void:
	generate_grid()
	
func generate_grid() -> void: 
	for i in grid_height:
		var row = HBoxContainer.new()
		row.theme = main_theme
		%GridContainer.add_child(row)
		for j in grid_width:
			var slot_instance:Slot = slot_scene.instantiate()
			if (i+j) == 8:
				slot_instance.add_plant_here(test_plant)
			
			if (i + j) % 2 :
				print(light_soil)
				slot_instance.soil_unplanted = light_soil
			else:
				print(dark_soil)
				slot_instance.soil_unplanted = dark_soil
			row.add_child(slot_instance)
	
func create_slot():
	pass
