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
	for planted_slot: Slot in array_of_slots:
		var found_neighbour 
		var neighbour_score
		#check left
		if planted_slot.index.x > 0:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x - 1, planted_slot.index.y)))
			print(found_neighbour)
			neighbour_score = calculate_neighbour(planted_slot.planted_plant, found_neighbour.get(0))
			score += neighbour_score
							
		#check right	
		if planted_slot.index.x < level.grid_width:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x + 1, planted_slot.index.y)))
			neighbour_score = calculate_neighbour(planted_slot.planted_plant, found_neighbour.get(0))
			score += neighbour_score
		#check top
		if planted_slot.index.y < level.grid_height:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x , planted_slot.index.y + 1)))
			neighbour_score = calculate_neighbour(planted_slot.planted_plant, found_neighbour.get(0))
			score += neighbour_score
		#check bottom
		if planted_slot.index.y > 0:
			found_neighbour = array_of_slots.filter(func(neighbour:Slot): return is_neighbour(neighbour, Vector2(planted_slot.index.x , planted_slot.index.y - 1)))
			neighbour_score = calculate_neighbour(planted_slot.planted_plant, found_neighbour.get(0))
			score += neighbour_score
		
	print(score)
	player_data.running_total_score = score;
	
func is_neighbour(neighbour:Slot, location: Vector2):
	return neighbour.index == location	

func calculate_neighbour(origin: Plant, neighbour: Slot) -> int:
	if neighbour == null:
		return 0;
	print("here"+origin.name + " "+neighbour.name)
	var neighbour_plant = neighbour.planted_plant
	if origin.compatible_matchup == neighbour_plant.name:
		return origin.base_stat * 2
	if origin.incompatible_matchup.size() > 0 && origin.incompatible_matchup.has(neighbour_plant.name):
		return origin.base_stat/ 2
	return 0

func compare_to_limit_for_level():
	#subtract value from data score then add back
	#for next level
	pass
