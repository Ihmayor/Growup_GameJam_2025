class_name TimerProgressBar extends Control

@export var increment: int

signal on_complete

func _ready() -> void:
	$TextureProgressBar.value = 0
	start_timer()

func start_timer():
	visible = true
	$Timer.start()

func _physics_process(delta: float):
	if $TextureProgressBar.value == $TextureProgressBar.max_value:
		on_complete.emit()
		stop_timer()

func stop_timer():
	$Timer.stop()
	visible = false
	$TextureProgressBar.value = 0

func _on_timer_timeout() -> void:
	$TextureProgressBar.value += increment
