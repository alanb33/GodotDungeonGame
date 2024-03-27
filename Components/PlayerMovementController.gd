class_name PlayerMovementController extends Node2D

var _parent = null

func connect_parent(entity: Entity):
	_parent = entity

func handle_movements(entity: Entity):
	if Input.is_action_just_pressed("ui_left"):
		print(entity.entity_name + " will move left")
	if Input.is_action_just_pressed("ui_right"):
		print("Right")
	if Input.is_action_just_pressed("ui_up"):
		print("up")
	if Input.is_action_just_pressed("ui_down"):
		print("Down")
		if _parent != null:
			_parent.move_to("5-5")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
