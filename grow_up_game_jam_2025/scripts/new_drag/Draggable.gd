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
var is_locking = false

signal on_moving
signal on_locking
signal on_particle_trigger(location)

var trowel = load("res://Assets/UI/TrowelCursor.png")

var original_position

func _ready():
	original_position = position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	var all_images = get_children().filter(func(n): return n is AnimatedSprite2D)
	for img:AnimatedSprite2D in all_images:
		img.animation = plant_data.name.to_lower()

func _on_mouse_entered():
	if (!is_planted && trowel != null):
		is_mouse_over = true
		Input.set_custom_mouse_cursor(trowel)

func _on_mouse_exited():
	is_mouse_over = false
	Input.set_custom_mouse_cursor(null)


func set_plant():
	var all_images = get_children().filter(func(n): return n is MaintainTextureUp)
	for img:MaintainTextureUp in all_images:
		img.position = img.original_position + img.rotate_offset 
		img.animation = plant_data.name.to_lower()
		img.play()
		

func lock_plant():
	if !is_mouse_over || is_planted || is_locking:
		return
	is_locking = true
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	var tween_sound = create_tween().set_trans(Tween.TRANS_EXPO)
	var all_images = get_children().filter(func(n): return n is MaintainTextureUp)
	on_particle_trigger.emit(global_position)
	for img:MaintainTextureUp in all_images:
		tween.tween_property(img, "position", img.position - img.rotate_offset/2, 0.4)
		tween_sound.tween_callback(_on_lock).set_delay(0.3)
	tween.finished.connect(_on_tween_lock_plant_finish)

func _on_tween_lock_plant_finish():
	is_planted = true
	

func _on_lock():
	on_locking.emit()

func _get_drag_data(at_position):
	if is_planted:
		return
	var preview_texture:Control = self.duplicate()
	preview_texture.modulate.a = 0.4
	preview_texture.name = "Preview"
	var c = Control.new()
	c.global_position = at_position - Vector2(16,16)
	c.add_child(preview_texture)
	preview_texture.position = Vector2.ZERO - at_position - Vector2(2,2)
	preview_control = preview_texture
	toggle_mouse_filter(true)
	set_drag_preview(c)
	return self

func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_DRAG_BEGIN:
			on_moving.emit()
			is_dragging = true
		NOTIFICATION_DRAG_END:
			is_dragging = false
			toggle_mouse_filter(false)
			reset_rotation()
		
#Allows the player to put a piece in a position that overlaps with its own position
#Prevents old positions from blocking new positions if you wanted to rotate or just shift it over
func toggle_mouse_filter(is_ignore:bool):
	var all_control = get_children().filter(func(n): return n is Control)
	print(all_control)
	if is_ignore:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		for img:Control in all_control:
			img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_PASS
		for img:Control in all_control:
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
	
	var find_slot_near_main_child = find_touching_slot()
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
			var all_images = get_children().filter(func(n): return n is AnimatedSprite2D)
			for img in all_images:
				img.position -= Vector2(0, 10)
			
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


func find_touching_slot():
	var center_area:Area2D = preview_control.find_child("Area2D", true,false)
	if center_area != null:
		return center_area.get_overlapping_areas()[0]
	else:
		return null

#Get the amount of plants that make up this mino
func get_draggable_size():
	var all_images = get_children().filter(func(n): return n is AnimatedSprite2D)
	return all_images.size()

func get_colliding_slots():
	var area:Area2D = preview_control.find_child("PlantCollisionArea", true,false)
	return area.get_overlapping_areas().map(func(n): return n.get_parent()).filter(func(s):return s!= self && s is Slot)

func _unhandled_input(event: InputEvent) -> void:
	if !is_dragging:
		if event.is_action_pressed("Shovel"):
			lock_plant()
	elif !is_planted:
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
	var tween = create_tween().set_ease(Tween.EASE_IN)
	var value = fmod((rotation_degrees + degrees), 360)
	rotation_degrees = value
	#rotation_degrees = 
	for child:MaintainTextureUp in children_textures:
		child.on_player_rotate()
	
