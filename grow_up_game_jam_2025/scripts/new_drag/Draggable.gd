class_name Draggable extends Control

var preview_control:Control
var array:Array[Vector2]
var curr_slots
func _get_drag_data(at_position):
	var preview_texture:Control = self.duplicate()
	preview_texture.modulate.a = 0.4
	var c = Control.new()
	c.add_child(preview_texture)
	preview_texture.position = Vector2.ZERO - at_position
	preview_control = preview_texture
	toggle_mouse_filter(true)
	set_drag_preview(c)
	return self

func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_DRAG_END:
			toggle_mouse_filter(false)
		
	
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

func snap_to_place():
	toggle_mouse_filter(false)
	var offset =  Vector2(0,-10)
	#We have the slots 
	print(get_child(0))
	var find_slot_near_main_child = find_closest_slot(preview_control.get_child(0).global_position)
	if find_slot_near_main_child != null :
		global_position = find_slot_near_main_child.global_position + offset
	else:
		print("error finding slot")
	
	if curr_slots != null:
		for old_slot:Slot in curr_slots:
			old_slot.isTaken = false
			old_slot.draggable_node = null
			
	
	curr_slots = get_colliding_slots()
	for slot:Slot in curr_slots:
		slot.isTaken = true
		slot.draggable_node = self

func find_closest_slot(found_position:Vector2):
	var closest_slot = null
	var closest_dist_sq:float = INF
	print(get_colliding_slots())
	for slot in get_colliding_slots():
		var slot_pos = slot.global_position
		print(slot_pos)
		print(found_position)
		var curr_dist_sq:float = slot_pos.distance_to(found_position)
		if curr_dist_sq < closest_dist_sq:
			closest_dist_sq = curr_dist_sq
			closest_slot = slot
	print(closest_slot.name)
	return closest_slot	
		
#Get the amount of plants that make up this mino
func get_draggable_size():
	return (get_children().size() - 2)

func get_colliding_slots():
	var area:Area2D = preview_control.find_child("PlantCollisionArea", true,false)
	return area.get_overlapping_areas().map(func(n): return n.get_parent()).filter(func(s):return s!= self)
