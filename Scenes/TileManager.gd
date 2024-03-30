class_name TileManager
extends Node

var _tiles: Dictionary = {}
var _rooms: Array = []

func add_room(room: Room):
	if room not in _rooms:
		_rooms.append(room)

func add_tile(tile: Tile):
	$TileContainer.add_child(tile)
	tile.owner = $TileContainer

func get_tile(coords: String):
	# TODO: Regex to detect if coords is in valid format of X-X where X are integers
	
	if _tiles[coords] != null:
		return _tiles[coords]
	else:
		return null
		
func get_tile_from_grid_position(grid_pos: Vector2):
	var coord_str = str(grid_pos.x) + "-" + str(grid_pos.y)
	return get_tile(coord_str) 

func merge_tiles(other_dictionary: Dictionary):
	# true refers to overwriting
	_tiles.merge(other_dictionary, true)
	
func OLD_get_random_passable_tile():
	var passable_tiles = []
	
	for tile in _tiles:
		if not _tiles[tile].terrain.impassable:
			passable_tiles.append(_tiles[tile])
			
	var chosen = passable_tiles.pick_random()
	chosen.sprite.modulate = Color(0,1,0)
	return chosen

func get_random_passable_tile():
	var room: Room = _rooms.pick_random()
	return room.get_random_passable_tile()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
