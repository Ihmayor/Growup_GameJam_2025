extends Node

signal on_final_plant_placed

func _ready():
	pass
			
func _process(delta: float):
	calculate_plant_total()
	pass
	
func calculate_plant_total():
	#get data socre 
	#for each plant 
	#check each neighbouring plant
	#check if matched dependency = plant base stat * 2 
	#check if mismatched dependency exist && mismatched dependency = plant_base_state /2 
	# add to total for plant
	# then add to grand total for score	
	#update data score
	pass

func compare_to_limit_for_level():
	#subtract value from data score then add back
	#for next level
	pass
