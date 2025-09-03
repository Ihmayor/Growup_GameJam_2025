class_name PlantScript extends Node2D
@export var text : Texture2D
@export var anim_name : String
@onready var timer = $Timer
@onready var textRect = $TextureRect
@onready var anim_sprite = $AnimatedSprite2D
@export var isPlanted = false
@export var ReboundOffset = Vector2(0,0)
@export var shoveledRecess = 10 # how far to inset when shoveled
var isShovelable = false

var occupyingSlot = null
var lastSlotEntered = null

var timeRan = 0
var maxTimeRan = 1.5

var trowel = load("res://Assets/UI/TrowelCursor.png")

func _ready() -> void:
	anim_sprite.play()

func _process(delta: float) -> void:
	textRect.texture = text
	if (anim_name != null):
		$AnimatedSprite2D.animation = anim_name
	set_cursor()

func set_cursor():
	if (self.isShovelable && !self.isPlanted):
		Input.set_custom_mouse_cursor(trowel)
	
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
	Input.set_custom_mouse_cursor(null)
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
	isShovelable = (get_parent().get_parent() as DraggablePlant).lastSlotEntered != null

func _on_area_2d_mouse_exited() -> void:
	isShovelable = false
	Input.set_custom_mouse_cursor(null)
	pass # Replace with function body.

func undo_occupation():
	if occupyingSlot:
		occupyingSlot.isTaken = false
		occupyingSlot.takenBy = null

#On enter has been unrealiable, using physics process tick instead
func _physics_process(delta: float) -> void:
	var areas_overlapping = %FlowerArea.get_overlapping_areas()
	var slot
	if areas_overlapping.size() > 1:
		slot = areas_overlapping[1].get_parent()
	
	if (occupyingSlot && occupyingSlot == slot) || slot == null:
		return
		
	print(areas_overlapping)
	if areas_overlapping.filter(func(n): return !n.name.contains("Slot")).size() > 2:
		print("slot is occupied")
		undo_occupation()
		occupyingSlot = null #Reset the spot 
	elif slot is Slot:
		undo_occupation()
		occupyingSlot = slot
		occupyingSlot.takenBy = get_parent()
		print("Claiming slot")
