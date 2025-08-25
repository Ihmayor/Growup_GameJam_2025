class_name GameManager extends Node

@export var level: LevelData 
@export var player_data: PlayerData
signal on_final_plant_placed


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("test_calculate")):
		calculate_plant_total()

func calculate_plant_total():
	#get data score 
	#for each plant 
	var score = 0
	var array_of_slots:Array[Node] = get_tree().get_nodes_in_group("Slots").filter(func(slot:Slot): return slot.planted_plant != null)
	if array_of_slots.size() == 0:
		return
	
	for planted_slot: Slot in array_of_slots:
		var found_neighbour 
		var neighbour_score
		var base_stat = planted_slot.planted_plant.base_stat
		
		#check left
		if planted_slot.index.x > 0:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x - 1, planted_slot.index.y)))
			base_stat = calculate_neighbour(planted_slot.planted_plant, found_neighbour,base_stat)
		
		#check right	
		if planted_slot.index.x < level.grid_width:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x + 1, planted_slot.index.y)))
			base_stat = calculate_neighbour(planted_slot.planted_plant, found_neighbour,base_stat)
		
		#check top
		if planted_slot.index.y < level.grid_height:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x , planted_slot.index.y + 1)))
			base_stat = calculate_neighbour(planted_slot.planted_plant, found_neighbour,base_stat)
		
		#check bottom
		if planted_slot.index.y > 0:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x , planted_slot.index.y - 1)))
			base_stat = calculate_neighbour(planted_slot.planted_plant, found_neighbour,base_stat)
		score += base_stat
	player_data.running_total_score = score;
	
func is_neighbour(neighbour:Slot, location: Vector2):
	return neighbour.index == location	

func calculate_neighbour(origin: Plant, neighbour: Array[Node], running_score:int) -> int:
	if neighbour == null || neighbour.size() == 0:
		return running_score;
	
	var neighbour_plant = neighbour.get(0).planted_plant
	print("found neighbour")
	print(origin.name + "is next to" +  neighbour.get(0).planted_plant.name)
	if origin.compatible_matchup == neighbour_plant.name:
		print("boost")
		return running_score + (origin.base_stat * 1.5)
	if origin.incompatible_matchup.size() > 0 && origin.incompatible_matchup.has(neighbour_plant.name):
		print("debuff")
		return running_score - (origin.base_stat / 2)
	return running_score

func compare_to_limit_for_level():
	#subtract value from data score then add back
	#for next level
	pass
