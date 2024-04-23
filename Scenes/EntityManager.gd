class_name EntityManager
extends Node

var _player_scene: PackedScene = preload("res://Scenes/Player.tscn")
var _enemy_scene: PackedScene = preload("res://Scenes/Entity/EntityMonsterSimple.tscn")
var _entities = []
var _player: Entity = null

signal entity_move_request(entity: Entity, dir: MoveTypes.Dir)
signal entity_action_request(entity: Entity, action: ActionTypes.Action)

signal entity_move_request_completed

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
		entity.action_request.connect(_on_action_request)
	
func place_player():
	var tile: Tile = _level_manager.get_any_passable_tile()
	if _player == null:
		_player = _player_scene.instantiate()
		add_child(_player)
	_player.position = tile.position
	_player.coordinate.make_equal_to(tile.coordinate)
	add_entity(_player)
	_player.update_vision()
	_connect_entities()
	
func place_enemy():
	var tile: Tile = _level_manager.get_any_passable_tile()
	var enemy = _enemy_scene.instantiate()
	enemy.position = tile.position
	enemy.coordinate.make_equal_to(tile.coordinate)
	add_child(enemy)
	add_entity(enemy)
	_connect_entities()
	print("enemy start pos: " + str(enemy.coordinate.vector2))
	
func update_player_vision():
	assert(_player != null, "Tried to update player vision, but player is null to EM")
	_player.update_vision()
	
func _on_action_request(entity: Entity, action: ActionTypes.Action):
	entity_action_request.emit(entity, action)
	await entity.complete_request()
	print("Action request completed")
	
func _on_move_request(entity: Entity, dir: MoveTypes.Dir):
	entity_move_request.emit(entity, dir)
	await entity.complete_request()
	print("Move request completed")
	entity_move_request_completed.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()

func _process(delta: float) -> void:
	# TODO: Write a proper system for an entity to report that its turn is finished. This will take some refactoring, since I only have prototype code for moving the player.
