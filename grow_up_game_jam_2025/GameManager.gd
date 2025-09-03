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
	var array_of_slots_taken:Array[Node] = get_tree().get_nodes_in_group("Slots").filter(func(slot:Slot): return slot.planted_plant != null)
	var total_slots = get_tree().get_nodes_in_group("Slots")
	#If there are no plants, return nothing
	if array_of_slots_taken.size() == 0:
		return
	
	var plant_neighbour_dictionary = {}
	var covered_plant = []
	var total_score = 0
	for planted_slot: Slot in array_of_slots_taken:
		var plant_id = planted_slot.plant_node.get_instance_id()
		
		if !plant_neighbour_dictionary.find_key(plant_id):
			plant_neighbour_dictionary[plant_id]= {"stat_data": planted_slot.planted_plant, "plant_ids": [], "plant_data":[] }

		var left_slot:Slot
		var right_slot:Slot
		if planted_slot.location.x > 0:
			var found_slot:Slot = total_slots.filter(func(n): return n.location == Vector2(planted_slot.location.x - 1, planted_slot.location.y)).get(0)
			if array_of_slots_taken.has(found_slot) && found_slot.plant_node != planted_slot.plant_node:
				left_slot = found_slot
				
		if planted_slot.location.x < level.grid_width:
			var found_slot:Slot = total_slots.filter(func(n): return n.location == Vector2(planted_slot.location.x + 1, planted_slot.location.y)).get(0)
			if array_of_slots_taken.has(found_slot) && found_slot.plant_node != planted_slot.plant_node:
				right_slot = found_slot
		
		if left_slot && !plant_neighbour_dictionary[plant_id].has(left_slot.plant_node.get_instance_id()):
			plant_neighbour_dictionary[plant_id]["plant_data"].append(left_slot.planted_plant)
			plant_neighbour_dictionary[plant_id]["plant_ids"].append(left_slot.plant_node.get_instance_id())
		
		if right_slot && !plant_neighbour_dictionary[plant_id].has(right_slot.plant_node.get_instance_id()):
			plant_neighbour_dictionary[plant_id]["plant_data"].append(right_slot.planted_plant)
			plant_neighbour_dictionary[plant_id]["plant_ids"].append(right_slot.plant_node.get_instance_id())
		
	
	for plant_id in plant_neighbour_dictionary.keys():
		print(plant_neighbour_dictionary[plant_id]["plant_ids"])
		total_score += calculate_neighbour(plant_neighbour_dictionary, plant_id, plant_neighbour_dictionary[plant_id]["stat_data"])
		
	player_data.running_total_score = total_score
func calculate_neighbour(plant_neighbour_dictionary, plant_id, main_plant_data:Plant) -> int:
	var neighbouring_plants = plant_neighbour_dictionary[plant_id]["plant_data"]
	print("neighbours")
	print(neighbouring_plants)
	for data in neighbouring_plants:
		print(main_plant_data.name)
		print(data.name)
	var comp_plants:Array = neighbouring_plants.filter(func(plant:Plant): return main_plant_data.compatible_matchup.contains(plant.name))
	print("compatible")
	print(comp_plants)
	
	var incomp_plants:Array =neighbouring_plants.filter(func(plant:Plant): return main_plant_data.incompatible_matchup.has(plant.name))
	print("incomp")
	print(incomp_plants)
	var effect_amount = main_plant_data.base_stat /2
	print("effect")
	print(effect_amount)
	var buff_amount = comp_plants.size() * effect_amount
	var debuff_amount = incomp_plants.size() * effect_amount
	print("to add")
	print(main_plant_data.base_stat + buff_amount - debuff_amount)
	return main_plant_data.base_stat + buff_amount - debuff_amount

func compare_to_limit_for_level():
	#subtract value from data score then add back
	#for next level
	pass
