class_name GardenUI extends Control

@onready var slot_scene = preload("res://slot.tscn");
@export var main_theme : Theme
@export var grid_width = 5;
@export var grid_height = 5;

func _ready() -> void:
	generate_grid()
	
func generate_grid() -> void: 
	for i in grid_height:
		var row = HBoxContainer.new()
		row.theme = main_theme
		
		%GridContainer.add_child(row)
		for j in grid_width:
			var slot_instance = slot_scene.instantiate()
			row.add_child(slot_instance)
	
func create_slot():
	pass
