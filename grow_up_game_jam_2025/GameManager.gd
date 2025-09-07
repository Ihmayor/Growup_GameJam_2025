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
	print("array of plants")
	print(array_of_slots_taken.size())

	#If there are no plants, return nothing
	if array_of_slots_taken.size() == 0:
		return
	
	var plant_neighbour_dictionary = {}
	var covered_plant = []
	var total_score = 0

	for planted_slot: Slot in array_of_slots_taken:
		var self_plant_node = planted_slot.plant_node
		var plant_id = self_plant_node.get_instance_id()
		if !plant_neighbour_dictionary.has(plant_id):
			plant_neighbour_dictionary[plant_id]= {"stat_data": planted_slot.planted_plant, "plant_ids": [], "plant_data":[] }

		var left_slot:Slot
		var right_slot:Slot
		var up_slot:Slot
		var down_slot:Slot

		#Check if Left Slot is Possible and check if it's taken by another plant
		if planted_slot.location.x > 0:
			var left_location = Vector2(planted_slot.location.x - 1, planted_slot.location.y)
			left_slot = find_taken_slot_by_location(total_slots, array_of_slots_taken, left_location, self_plant_node)

		#Check if Right Slot is Possible and check if it's taken by another plant
		if planted_slot.location.x < level.grid_width -1:
			var right_location = Vector2(planted_slot.location.x + 1, planted_slot.location.y)
			right_slot = find_taken_slot_by_location(total_slots, array_of_slots_taken, right_location, self_plant_node)
		
		#Check if Up slot is possible and check if it's taken by another plant
		if planted_slot.location.y > 0:
			var up_location = Vector2(planted_slot.location.x, planted_slot.location.y -1)
			up_slot = find_taken_slot_by_location(total_slots, array_of_slots_taken, up_location, self_plant_node)

		#Check if Down slot is possible and check if it's taken by another plant
		if planted_slot.location.y < level.grid_height -1:
			var down_location = Vector2(planted_slot.location.x, planted_slot.location.y + 1)
			down_slot = find_taken_slot_by_location(total_slots, array_of_slots_taken, down_location, self_plant_node)

		add_slot_if_planted(left_slot, plant_neighbour_dictionary, plant_id)
		add_slot_if_planted(right_slot, plant_neighbour_dictionary, plant_id)
		add_slot_if_planted(up_slot, plant_neighbour_dictionary, plant_id)
		add_slot_if_planted(down_slot, plant_neighbour_dictionary, plant_id)

	for plant_id in plant_neighbour_dictionary.keys():
		print(plant_neighbour_dictionary[plant_id]["plant_ids"])
		total_score += calculate_neighbour(plant_neighbour_dictionary, plant_id, plant_neighbour_dictionary[plant_id]["stat_data"])
	player_data.running_total_score = total_score

func add_slot_if_planted(new_slot:Slot, plant_neighbour_dictionary, plant_id ):
	if new_slot && !plant_neighbour_dictionary[plant_id]["plant_ids"].has(new_slot.plant_node.get_instance_id()):
		plant_neighbour_dictionary[plant_id]["plant_data"].append(new_slot.planted_plant)
		plant_neighbour_dictionary[plant_id]["plant_ids"].append(new_slot.plant_node.get_instance_id())


func find_taken_slot_by_location(total_slots:Array[Node], array_of_slots_taken:Array[Node], location_vector:Vector2, self_node: Node):
	var found_slot = total_slots.filter(func(n): return n.location == location_vector).get(0)
	if array_of_slots_taken.has(found_slot) && found_slot.plant_node != self_node:
		return found_slot
	else:
		return null

func calculate_neighbour(plant_neighbour_dictionary, plant_id, main_plant_data:Plant) -> int:
	var neighbouring_plants = plant_neighbour_dictionary[plant_id]["plant_data"]
	print("neighbours")
	print(neighbouring_plants)
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
