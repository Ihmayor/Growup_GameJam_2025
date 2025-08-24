class_name DraggablePlant extends Node2D
@onready var A2D =  $Area2D
@onready var timer = $Area2D/DragTimer
@onready var shape = $Area2D/CollisionShape2D

@onready var rotationTween = $RotationTweenTimer

@export var plant_data: Plant
@onready var images = $Images

@export var imageToUse : Texture2D

# 0-3 depending on what direction you wanna feace, 0 being staright up
var facingDir = 0
var desiredRotation = 0
var rotateIncrement = 10

# the direction the player wants to rotate
var rotationInput = 1

var isDragging = false
var isPlanted = false

var gridSize = 32

var mouse_over:bool = false

func UpdateImages():
	var img = $Images
	var node = $Images
	
	var imagesToChange = images.get_children()
	for image in imagesToChange:
		image.text = imageToUse

func _ready() -> void:
	if (plant_data != null): 
		$PlantTexture.texture = plant_data.first_image
	UpdateImages()
	pass

func _on_area_2d_mouse_entered() -> void:
	mouse_over = true
	timer.start()
	
func _on_area_2d_mouse_exited() -> void:
	mouse_over = false

func _on_timer_timeout() -> void:
	if isDragging && !isPlanted:
		var rect = shape.shape as RectangleShape2D
		var sizeVector = rect.extents
		
		var newPos = get_viewport().get_mouse_position() - sizeVector/2
		self.position = round (newPos / gridSize) * gridSize
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	var changed = false
	if event.is_action_pressed("rotate_left"):
		facingDir -= 1
		rotationInput = -1
		changed = true
		
	if event.is_action_pressed("rotate_right"):
		facingDir += 1
		rotationInput = 1
		changed = true
			
	if (event.is_action_released("move")):
		isDragging = false
		timer.stop()
		
		if event.is_action_pressed("Shovel"):
			SetShoveled()
			
	var get_other_plants = get_tree().get_nodes_in_group("Plants");
	var test = get_other_plants.filter(func(plant: DraggablePlant): return plant.isDragging == true && plant.name != self.name)
	var is_another_plant_being_dragged = get_other_plants.filter(func(plant: DraggablePlant): return plant.isDragging == true && plant.mouse_over).size() > 0
	
	if (event.is_action_pressed("move") && !is_another_plant_being_dragged):
		isDragging = true

			
	if changed && isDragging:
			# clamp the value to avoid broken stuff
		if (facingDir < 0):
			facingDir = 3
		if (facingDir > 3):
			facingDir = 0
			
		_rotate(facingDir)
	pass

func _rotate (newRotation) -> void:
	# clamp the value to avoid broken stuff
	if (newRotation < 0):
		newRotation = 0
	if (newRotation > 3):
		newRotation = 3
		
	#rotation_degrees = 90 * newRotation
	desiredRotation = 90 * newRotation
	rotationTween.start()
	pass 

func SetShoveled():
	var childPlants = images.get_children()
	
	for cPlant in childPlants:
		if (cPlant.isPlanted):
			isPlanted = true
	pass
	
func _on_rotation_tween_timer_timeout() -> void:	
	# Fix issue with rotationd degrees over to values over 90000
	if abs(rotation_degrees) > 360:
		rotation_degrees = 0
	
	# Fix rotationg to the left
	if (rotationInput < 0 && desiredRotation > 180 && rotation_degrees == 0):
		rotation_degrees = 360
		
	rotation_degrees += rotateIncrement * rotationInput
	
	# Stop rotating when desired is reached
	var distFromDesired = abs (rotation_degrees) - desiredRotation 
	if abs (distFromDesired) <= rotateIncrement * 1.15:
		rotationTween.stop()
		rotation_degrees = desiredRotation
	
	pass # Replace with function body.
