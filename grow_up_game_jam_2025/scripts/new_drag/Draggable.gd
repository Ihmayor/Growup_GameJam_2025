class_name Draggable extends Control

#Drag Related Variables
var preview_control:Control
var array:Array[Vector2]
var curr_slots

#Rotation Related Variables
var rotationInput = 0
var has_rotation_changed = false
var facingDir = 0 

@export var plant_data:Plant

var is_dragging = false
var is_mouse_over = false


var is_planted = false


func _ready():
	var all_images = get_children().filter(func(n): return n is TextureRect)
	for img in all_images:
		img.texture = plant_data.first_image

func set_plant():
	var all_images = get_children().filter(func(n): return n is TextureRect)
	for img in all_images:
		img.texture = plant_data.first_image


func _get_drag_data(at_position):
	var preview_texture:Control = self.duplicate()
	preview_texture.modulate.a = 0.4
	preview_texture.name = "Preview"
	var c = Control.new()
	c.add_child(preview_texture)
	preview_texture.position = Vector2.ZERO - at_position
	preview_control = preview_texture
	toggle_mouse_filter(true)
	set_drag_preview(c)
	return self

func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_DRAG_BEGIN:
			is_dragging = true
		NOTIFICATION_DRAG_END:
			is_dragging = false
			toggle_mouse_filter(false)
			reset_rotation()
		
		
#Allows the player to put a piece in a position that overlaps with its own position
#Prevents old positions from blocking new positions if you wanted to rotate or just shift it over
func toggle_mouse_filter(is_ignore:bool):
	if is_ignore:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var all_images = get_children().filter(func(n): return n is TextureRect)
		for img:TextureRect in all_images:
			img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_PASS
		var all_images = get_children().filter(func(n): return n is TextureRect)
		for img:TextureRect in all_images:
			img.mouse_filter = Control.MOUSE_FILTER_PASS

func temp_spot(at_position:Vector2):
	if (curr_slots != null):
		reset_slots()
		curr_slots = null
	global_position = at_position
	


func snap_to_place():
	toggle_mouse_filter(false)
	
	#Adjust to the size of the slot since the position if the top left slot
	var offset = Vector2(16,16)
	
	var find_slot_near_main_child = find_closest_slot(preview_control.get_child(0).global_position)
	if find_slot_near_main_child != null :
		global_position = find_slot_near_main_child.global_position + offset
	
	if curr_slots != null:
		reset_slots()
			
	curr_slots = get_colliding_slots()
	for slot:Slot in curr_slots:
		slot.isTaken = true
		slot.draggable_node = self
		slot.add_plant_here(plant_data)
	
	#Handle Rotation
	if has_rotation_changed:
		if rotationInput != 0:
			for i in range(abs(rotationInput)):
				rotate_self_and_children(rotationInput < 0)
		reset_rotation()

func reset_rotation():
	has_rotation_changed = false
	rotationInput = 0

func reset_slots():
	for old_slot:Slot in curr_slots:
			old_slot.isTaken = false
			old_slot.draggable_node = null
			old_slot.remove_plant()


func find_closest_slot(found_position:Vector2):
	var closest_slot = null
	var closest_dist_sq:float = INF
	for slot in get_colliding_slots():
		var slot_pos = slot.global_position - Vector2(4,4)
		var curr_dist_sq:float = slot_pos.distance_to(found_position)
		if curr_dist_sq < closest_dist_sq:
			closest_dist_sq = curr_dist_sq
			closest_slot = slot
	return closest_slot	
		
#Get the amount of plants that make up this mino
func get_draggable_size():
	var all_images = get_children().filter(func(n): return n is TextureRect)
	return all_images.size()

func get_colliding_slots():
	var area:Area2D = preview_control.find_child("PlantCollisionArea", true,false)
	return area.get_overlapping_areas().map(func(n): return n.get_parent()).filter(func(s):return s!= self)

func _unhandled_input(event: InputEvent) -> void:
	if !is_dragging:
		return
	if event.is_action_pressed("rotate_left"):
		if preview_control != null:
			rotationInput = (rotationInput -1) % -4
			has_rotation_changed = true
		if self.name.contains("Preview"):
			rotate_self_and_children(true)
			global_position = get_global_mouse_position()
					
	if event.is_action_pressed("rotate_right"):
		if preview_control != null:
			rotationInput = (rotationInput + 1) % 4
			has_rotation_changed = true
		if self.name.contains("Preview"):
			rotate_self_and_children(false)
			global_position = get_global_mouse_position()
		
func rotate_self_and_children(is_left:bool):
	var children_textures = get_children().filter(func(n): return n is MaintainTextureUp);
	var degrees = 90
	if !is_left:
		degrees *= -1
	rotation_degrees = fmod((rotation_degrees + degrees), 360)
	for child:MaintainTextureUp in children_textures:
		child.rotate()
	
