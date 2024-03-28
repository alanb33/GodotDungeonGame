class_name EntityManager
extends Node

var _player_scene: PackedScene = preload("res://Scenes/Player.tscn")

@export var _tile_manager: TileManager

func _test_links():
	assert(_player_scene.can_instantiate())
	assert(_tile_manager != null)
	
func place_player():
	var tile: Tile = _tile_manager.get_random_passable_tile()
	var player: Entity = _player_scene.instantiate()
	add_child(player)
	player.position = tile.position
	player.player_move_request.connect(_on_player_move_request)
	
func _on_player_move_request(entity: Entity, dir: String):
	assert(entity.tile_pos != "X-X", entity.entity_name + " tried to move, but initial position was never set")
	print("Move request from " + str(entity.entity_name) + " received to " + dir)
	print(entity.entity_name + " tile pos: " + str(entity.tile_pos))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
