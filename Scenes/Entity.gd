class_name Entity extends Node2D

signal player_move_request(entity, dir)

@onready var _components = $Components
@export var entity_name: String = "Entity"

var _tile_pos = "X-X"
var tile_pos: String:
	get:
		return _tile_pos
	set(value):
		_tile_pos = value
		print("New tile pos " + str(value))

# Possible components
var _sprite = null

# Player control-related
var _player_movement_controller = null

func _connect_components():
	for component in _components.get_children():
		if component is Sprite2D:
			_sprite = component
		if component is PlayerMovementController:
			_player_movement_controller = component
			_player_movement_controller.move_request.connect(_on_player_movement_request)

func _on_player_movement_request(dir: String):
	player_move_request.emit(self, dir)

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_components()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _player_movement_controller != null:
		_player_movement_controller.handle_movements(self)
