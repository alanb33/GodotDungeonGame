class_name EntityManager
extends Node

@export var _tile_manager: TileManager

func _test_links():
	assert(_tile_manager != null)
	
func place_player():
	var tile: Tile = _tile_manager.get_random_passable_tile()
	print("Passable tile at: " + str(tile.grid_position))
	tile.sprite.modulate = Color(0,1,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
