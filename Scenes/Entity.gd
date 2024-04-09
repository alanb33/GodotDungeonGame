class_name Entity extends Node2D

signal action_request(entity: Entity, action: ActionTypes.Action)
signal move_request(entity: Entity, dir: MoveTypes.Dir)

@onready var _components = $Components
@export var entity_name: String = "Entity"
@export var player_controlled: bool = false

var coordinate: Coordinate = Coordinate.new()

# Possible components
var _sprite: Sprite2D = null

# Player control-related
var _player_movement_controller = null
var _player_action_controller = null

var movement_locked := false

func _connect_components():
	for component in _components.get_children():
		if component is Sprite2D:
			_sprite = component
			_prepare_sprite()
		if component is PlayerMovementController:
			_player_movement_controller = component
			_player_movement_controller.move_request.connect(_on_move_request)
		if component is PlayerActionController:
			_player_action_controller = component
			_player_action_controller.action_request.connect(_on_action_request)

func _on_action_request(action: ActionTypes.Action):
	if player_controlled:
		match action:
			ActionTypes.Action.ACTION_CLOSE:
				movement_locked = true
			ActionTypes.Action.ACTION_OPEN:
				movement_locked = true
	action_request.emit(self, action)

func _on_move_request(dir: MoveTypes.Dir):
	if not movement_locked:
		move_request.emit(self, dir)

func _prepare_sprite():
	_sprite.scale.x = TileInfo.CURRENT_DIMENSIONS.x / TileInfo.BASE_DIMENSIONS.x
	_sprite.scale.y = TileInfo.CURRENT_DIMENSIONS.y / TileInfo.BASE_DIMENSIONS.y

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_components()
