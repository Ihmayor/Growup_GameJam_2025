class_name GardenUI extends Control

@onready var slot_scene = preload("res://slot.tscn");
@export var main_theme : Theme

func _ready() -> void:
	generate_grid()
	
func generate_grid() -> void: 
	for i in 5:
		var row = HBoxContainer.new()
		row.theme = main_theme
		%GridContainer.add_child(row)
		for j in 5:
			var slot_instance = slot_scene.instantiate()
			#add children to the row above 
			row.add_child(slot_instance)
	
func create_slot():
	pass
