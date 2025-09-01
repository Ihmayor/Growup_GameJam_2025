extends Node2D
@export var text : Texture2D
@onready var timer = $Timer
@onready var textRect = $TextureRect
@export var isPlanted = false
@export var ReboundOffset = Vector2(0,0)
@export var shoveledRecess = 10 # how far to inset when shoveled
var isShovelable = false

var occupyingSlot = null
var lastSlotEntered = null

var timeRan = 0
var maxTimeRan = 1.5

func _process(delta: float) -> void:
	textRect.texture = text
	
func _unhandled_input(event: InputEvent) -> void:
	var changed = false
	if event.is_action_pressed("rotate_left"):
		timeRan = 0
		timer.start()
		pass
		
	if event.is_action_pressed("rotate_right"):
		timeRan = 0
		timer.start()
		pass
		
	if (event.is_action_pressed("Shovel") && isShovelable && !isPlanted):
		Shovel()
		pass
		
	pass
	
	
func Shovel ():
	print("Shoveled")
	isPlanted = true
	(get_tree().get_first_node_in_group("manager") as GameManager).calculate_plant_total()
	global_position -= Vector2(0, -shoveledRecess)
	pass


func _on_timer_timeout() -> void:
	global_rotation_degrees = 0
	
	timeRan += 0.01
	if (timeRan >= maxTimeRan):
		timer.stop()
	pass # Replace with function body.


func _on_area_2d_mouse_entered() -> void:
	isShovelable = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	isShovelable = false
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	var slot = area.get_parent()
	
	# exit of slot is unoccupiable
	if !(slot is Slot && (slot.takenBy == null || slot.takenBy == get_parent())):
		if occupyingSlot:
			occupyingSlot.isTaken = false
			occupyingSlot.takenBy = null
		occupyingSlot = null
		print("NULL SLOT")
		return
		
	# reset old slot when leaving a slot
	if (occupyingSlot):
		occupyingSlot.isTaken = false
		occupyingSlot.takenBy = null
		
	occupyingSlot = slot
	occupyingSlot.takenBy = get_parent()	
	pass # Replace with function body.
