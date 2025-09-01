class_name DraggablePlant extends Node2D
@onready var A2D =  $Area2D
@onready var timer = $Area2D/DragTimer
@onready var shape = $Area2D/CollisionShape2D

@onready var rotationTween = $RotationTweenTimer

@export var plant_data: Plant
@export var offset = Vector2 (32/2,32/2)
@onready var images = $Images
var lastSlotEntered = null
var lastSlotRotation = 0
var lastSlotPosition = Vector2(0,0)

static var currentlyDragging = null
static var isSOmethingBeingDragged = false

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
		image.text = plant_data.first_image

func _ready() -> void:
	if (plant_data != null): 
		$Images/Flower.text = plant_data.first_image
	UpdateImages()
	pass

func _on_area_2d_mouse_entered() -> void:
	mouse_over = true
	
	if isSOmethingBeingDragged:
		print("Already dragging something")
		return
	currentlyDragging = self
	
	timer.start()
	
func _on_area_2d_mouse_exited() -> void:
	currentlyDragging = null
	mouse_over = false
	
func _on_timer_timeout() -> void:
	if isDragging && !isPlanted && currentlyDragging == self:
		isSOmethingBeingDragged = true	
		var rect = shape.shape as RectangleShape2D
		var sizeVector = rect.extents
		
		var newPos = get_viewport().get_mouse_position() - sizeVector/2
		
		self.global_position = round (newPos / gridSize) * gridSize + offset
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	var changed = false

	if event.is_action_pressed("Shovel"):
		SetShoveled()
			
	if event.is_action_pressed("rotate_left"):
		facingDir -= 1
		rotationInput = -1
		changed = true
		
	if event.is_action_pressed("rotate_right"):
		facingDir += 1
		rotationInput = 1
		changed = true
	if (event.is_action_pressed("move")):
		if (!isSOmethingBeingDragged):
			isDragging = true
		
	if (event.is_action_released("move")):
		isSOmethingBeingDragged = false
		timer.stop()

		ClampToGrid()
		isDragging = false
		currentlyDragging = null
			
	if changed && isDragging && currentlyDragging == self:
			# clamp the value to avoid broken stuff
		if (facingDir < 0):
			facingDir = 3
		if (facingDir > 3):
			facingDir = 0
			
		_rotate(facingDir)


func _rotate (newRotation) -> void:
	# clamp the value to avoid broken stuff
	if (newRotation < 0):
		newRotation = 0
	if (newRotation > 3):
		newRotation = 3
		
	desiredRotation = 90 * newRotation
	rotationTween.start()
	pass 


func SetShoveled():
	var childPlants = images.get_children()
	
	for cPlant in childPlants:
		if (cPlant.isPlanted):
			#print("Unmovable due to planted set")
			isPlanted = true
	pass
	

# Clamps the tile to the specific grid
func ClampToGrid ():
	if (lastSlotEntered != null && isDragging):
		print("CLAMPING TO ", lastSlotEntered.global_position + offset, "CURRENT POSITION IS: ", position)
		var desiredPos = lastSlotPosition + offset
		
		global_position = desiredPos
		rotation_degrees = 90 * lastSlotRotation
		
		print("Clamp rotation is: ", 90 * lastSlotRotation)
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
		_test_for_collision()
	
	pass # Replace with function body.


func _test_for_collision():

	var canBePlantedHere = true
	var flowers = images.get_children()
	
	for flower in flowers:
		if (flower.occupyingSlot == null ):
			canBePlantedHere = false
			
			print("Can't be planted ", flower.occupyingSlot)
			break
			
	if (canBePlantedHere ):
		lastSlotRotation = facingDir
		pass
	return canBePlantedHere
	


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	await get_tree().create_timer(0.01).timeout
	var slot = area.get_parent()
	print("Entered area ", slot.name)
	var canBePlantedHere = _test_for_collision()
	
	# Why does making this only trigger sometimes
	# cause snapping to just stop working?
	if (slot is Slot && canBePlantedHere ):
		lastSlotEntered = slot
		lastSlotRotation = facingDir
		lastSlotPosition = lastSlotEntered.global_position
		print("setting last slot entered ", lastSlotEntered.global_position, " With rotation ", lastSlotRotation)

		lastSlotEntered.isTaken = true
		pass
	pass # Replace with function body.
