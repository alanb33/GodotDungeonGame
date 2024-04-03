class_name Room

var _all_tiles: Dictionary = {}
var _passable_tiles: Dictionary = {}
var _impassable_tiles: Dictionary = {}

var pos: Vector2 = Vector2.ZERO
var size: Vector2 = Vector2.ZERO

func overlaps_with(other_room: Room):
	
	var other_tiles = other_room.get_all_tiles()
	
	for our_key in _all_tiles.keys():
		for other_key in other_tiles.keys():
			if _all_tiles[our_key].coordinate.string == other_tiles[other_key].coordinate.string:
				return true
	
	return false

func add_tile(tile: Tile):
	var key = tile.coordinate.string
	_all_tiles[key] = tile
	if tile.terrain.impassable:
		_impassable_tiles[key] = tile
	else:
		_passable_tiles[key] = tile
		
func get_tile_by_coordinate_string(coordinate_string: String) -> Tile:
	return _all_tiles.get(coordinate_string)
		
func has_tile_by_coordinate_string(coordinate_string: String) -> bool:
	if _all_tiles.get(coordinate_string):
		return true
	return false
	
func is_coordinate_string_in_corner(coordinate_string: String):
	var nw = TileInfo.vector_to_coordinate_string(pos.x, pos.y)
	var ne = TileInfo.vector_to_coordinate_string(pos.x + size.x, pos.y)
	var sw = TileInfo.vector_to_coordinate_string(pos.x, pos.y + size.y)
	var se = TileInfo.vector_to_coordinate_string(pos.x + size.x, pos.y + size.y)
	
	var coords = [nw, ne, sw, se]
	
	if coordinate_string in coords:
		return true
	return false

func merge_tiles(incoming_tiles: Dictionary):

	_all_tiles.merge(incoming_tiles, true)
	
	for key in _all_tiles:
		var tile = _all_tiles[key]
		if tile.terrain.impassable:
			_impassable_tiles[key] = tile
		else:
			_passable_tiles[key] = tile
			
	assert(len(_passable_tiles.keys()) + len(_impassable_tiles.keys()) > 0, "Room was created but had no passable or impassable tiles")
			
func get_random_passable_tile():
	return _passable_tiles[_passable_tiles.keys().pick_random()]
	
func get_random_impassable_tile():
	return _impassable_tiles[_impassable_tiles.keys().pick_random()]

func get_all_tiles():
	return _all_tiles
	
func get_passable_tiles():
	return _passable_tiles

func get_impassable_tiles():
	return _impassable_tiles
