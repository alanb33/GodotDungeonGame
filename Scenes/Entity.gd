class_name Entity extends Node2D

signal move_request(entity: Entity, dir: MoveTypes.Dir)

@onready var _components = $Components
@export var entity_name: String = "Entity"

var _tile_pos = "X-X"
var tile_pos_str: String:
	get:
		return _tile_pos
	set(value):
		_tile_pos = value

# Possible components
var _sprite: Sprite2D = null

# Player control-related
var _player_movement_controller = null

func _connect_components():
	for component in _components.get_children():
		if component is Sprite2D:
			_sprite = component
			_prepare_sprite()
		if component is PlayerMovementController:
			_player_movement_controller = component
			_player_movement_controller.move_request.connect(_on_move_request)

func _on_move_request(dir: MoveTypes.Dir):
	move_request.emit(self, dir)

func _prepare_sprite():
	_sprite.scale.x = TileInfo.CURRENT_DIMENSIONS.x / TileInfo.BASE_DIMENSIONS.x
	_sprite.scale.y = TileInfo.CURRENT_DIMENSIONS.y / TileInfo.BASE_DIMENSIONS.y

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_components()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _player_movement_controller != null:
		_player_movement_controller.handle_movements(self)
