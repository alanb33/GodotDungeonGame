class_name PlayerMovementController extends Node2D

signal move_request(dir: MoveTypes.Dir)

func handle_movements():
	if Input.is_action_just_pressed("ui_left"):
		move_request.emit(MoveTypes.Dir.LEFT)
	if Input.is_action_just_pressed("ui_right"):
		move_request.emit(MoveTypes.Dir.RIGHT)
	if Input.is_action_just_pressed("ui_up"):
		move_request.emit(MoveTypes.Dir.UP)
	if Input.is_action_just_pressed("ui_down"):
		move_request.emit(MoveTypes.Dir.DOWN)
	if Input.is_action_just_pressed("ui_accept"):
		move_request.emit(MoveTypes.Dir.RANDOM)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
