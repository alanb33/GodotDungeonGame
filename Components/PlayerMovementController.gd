class_name PlayerMovementController extends Node2D

signal move_request(dir)

func handle_movements(entity: Entity):
	if Input.is_action_just_pressed("ui_left"):
		move_request.emit("left")
	if Input.is_action_just_pressed("ui_right"):
		move_request.emit("right")
	if Input.is_action_just_pressed("ui_up"):
		move_request.emit("up")
	if Input.is_action_just_pressed("ui_down"):
		move_request.emit("down")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
