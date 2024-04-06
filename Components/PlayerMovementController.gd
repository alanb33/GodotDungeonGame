class_name PlayerMovementController extends Node2D

signal move_request(dir: MoveTypes.Dir)

func _input(event):
	if event.is_action_pressed("ui_left"):
		move_request.emit(MoveTypes.Dir.LEFT)
	if event.is_action_pressed("ui_right"):
		move_request.emit(MoveTypes.Dir.RIGHT)
	if event.is_action_pressed("ui_up"):
		move_request.emit(MoveTypes.Dir.UP)
	if event.is_action_pressed("ui_down"):
		move_request.emit(MoveTypes.Dir.DOWN)
	if event.is_action_pressed("ui_nw"):
		move_request.emit(MoveTypes.Dir.NW)
	if event.is_action_pressed("ui_ne"):
		move_request.emit(MoveTypes.Dir.NE)
	if event.is_action_pressed("ui_se"):
		move_request.emit(MoveTypes.Dir.SE)
	if event.is_action_pressed("ui_sw"):
		move_request.emit(MoveTypes.Dir.SW)
	if event.is_action_pressed("ui_accept"):
		move_request.emit(MoveTypes.Dir.RANDOM)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
