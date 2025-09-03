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
	
	var total_score = 0
	for planted_slot: Slot in array_of_slots_taken:
		var plant_id = planted_slot.plant_node.get_instance_id()
		if !plant_neighbour_dictionary.find_key(plant_id):
			plant_neighbour_dictionary[plant_id]["plant_ids"] = []
			plant_neighbour_dictionary[plant_id]["plant_data"] = []
		var slot_index = planted_slot.get_index()
		var left_slot:Slot
		var right_slot:Slot
		if slot_index > 0:
			var found_slot:Slot = total_slots.get(slot_index -1)
			if array_of_slots_taken.has(found_slot):
				left_slot = found_slot
				
		if slot_index < total_slots.size():
			var found_slot:Slot = total_slots.get(slot_index + 1)
			if array_of_slots_taken.has(found_slot):
				right_slot = found_slot
		
		if left_slot && !plant_neighbour_dictionary[plant_id].has(left_slot.plant_node.get_instance_id()):
			plant_neighbour_dictionary[plant_id]["plant_data"].append(left_slot.planted_plant)
			plant_neighbour_dictionary[plant_id]["plant_ids"].append(left_slot.plant_node.get_instance_id())
		
		if right_slot && !plant_neighbour_dictionary[plant_id].has(right_slot.plant_node.get_instance_id()):
			plant_neighbour_dictionary[plant_id]["plant_data"].append(right_slot.planted_plant)
			plant_neighbour_dictionary[plant_id]["plant_ids"].append(right_slot.plant_node.get_instance_id())
		
		total_score += calculate_neighbour(plant_neighbour_dictionary, plant_id, planted_slot.planted_plant)

func calculate_neighbour(plant_neighbour_dictionary, plant_id, main_plant_data:Plant) -> int:
	var comp_plants:Array = plant_neighbour_dictionary[plant_id]["plant_data"].filter(func(plant:Plant): return main_plant_data.compatible_matchup.contains(plant.name))
	var incomp_plants:Array = plant_neighbour_dictionary[plant_id]["plant_data"].filter(func(plant:Plant): return main_plant_data.incompatible_matchup.has(plant.name))

	var effect_amount = main_plant_data.base_stat /2
	
	var buff_amount = comp_plants.size() * effect_amount
	var debuff_amount = incomp_plants.size() * effect_amount
	
	return main_plant_data.base_stat + buff_amount - debuff_amount

func compare_to_limit_for_level():
	#subtract value from data score then add back
	#for next level
	pass
