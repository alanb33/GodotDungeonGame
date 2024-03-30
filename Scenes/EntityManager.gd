class_name EntityManager
extends Node

var _player_scene: PackedScene = preload("res://Scenes/Player.tscn")
var _entities = []

enum Directions {
	LEFT,
	UP,
	RIGHT,
	DOWN,
}

@export var _tile_manager: TileManager

func _test_links():
	assert(_player_scene.can_instantiate())
	assert(_tile_manager != null)
	
func add_entity(entity: Entity):
	if entity not in _entities:
		_entities.append(entity)
	
func _connect_entities():
	for entity in _entities:
		entity.move_request.connect(_on_move_request)
		print("Connected " + entity.entity_name)
	
func place_player():
	var tile: Tile = _tile_manager.get_random_passable_tile()
	var player: Entity = _player_scene.instantiate()
	add_child(player)
	player.position = tile.position
	player.tile_pos = tile.grid_position_as_coordinates()
	add_entity(player)
	_connect_entities()
	
func _on_move_request(entity: Entity, dir: MoveTypes.Dir):
	assert(entity.tile_pos != "X-X", entity.entity_name + " tried to move, but initial position was never set")
	print("Move request from " + str(entity.entity_name) + " received to " + MoveTypes.dir_str(dir))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
