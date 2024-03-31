class_name EntityManager
extends Node

var _player_scene: PackedScene = preload("res://Scenes/Player.tscn")
var _entities = []

signal entity_move_request(entity: Entity, dir: MoveTypes.Dir)

enum Directions {
	LEFT,
	UP,
	RIGHT,
	DOWN,
}

@export var _level_manager: LevelManager

func _test_links():
	assert(_player_scene.can_instantiate())
	assert(_level_manager != null)
	
func add_entity(entity: Entity):
	if entity not in _entities:
		_entities.append(entity)
	
func _connect_entities():
	for entity in _entities:
		entity.move_request.connect(_on_move_request)
		print("Connected " + entity.entity_name)
	
func place_player():
	var tile: Tile = _level_manager.get_any_passable_tile()
	var player: Entity = _player_scene.instantiate()
	add_child(player)
	player.position = tile.position
	player.coordinate.make_equal_to(tile.coordinate)
	add_entity(player)
	_connect_entities()
	
func _on_move_request(entity: Entity, dir: MoveTypes.Dir):
	entity_move_request.emit(entity, dir)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
