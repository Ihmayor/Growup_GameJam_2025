extends Node2D
@export var text : Texture2D
@onready var timer = $Timer
@onready var textRect = $TextureRect
@export var isPlanted = false
@export var shoveledRecess = 10 # how far to inset when shoveled
var isShovelable = false

var timeRan = 0
var maxTimeRan = 1.5


func _ready() -> void:
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
