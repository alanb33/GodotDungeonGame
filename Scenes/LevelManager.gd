class_name LevelManager
extends Node

@export var _tile_maker: TileMaker = null

var _all_tiles: Dictionary = {}
var _passable_tiles: Dictionary = {}
var _impassable_tiles: Dictionary = {}

var _feature_tiles = {}

var _rooms: Array = []

func valid_room(new_room: Room):
	for room in _rooms:
		if new_room.overlaps_with(room):
			return false
	return true
	
func add_feature(tile: Tile):
	assert(tile.feature != null, "Tried to add a tile with a null feature to LM")
	assert(tile.feature.type != Feature.Type.None, "Tried to add a tile with a None-type feature")
	
	var ftype = tile.feature.type
	
	if _feature_tiles.get(ftype) == null:
		_feature_tiles[ftype] = []
	_feature_tiles[ftype].append(tile)
	
	var room = get_room_by_tile(tile)
	if room != null:
		room.add_feature(tile)
		
func get_features_of_type(type: Feature.Type):
	return _feature_tiles.get(type)
	
func get_features_of_type_in_room_from_tile(type: Feature.Type, tile: Tile):
	var room = get_room_by_tile(tile)
	if room != null:
		return room.get_features_of_type(type)
	return null

func add_room(room: Room):
	if room not in _rooms:
		_rooms.append(room)
		
		for key in room.get_all_tiles():
			if _all_tiles.get(key) != null:
				_all_tiles[key].queue_free()
		
		_all_tiles.merge(room.get_all_tiles(), true) # Overwrite any existing
		_passable_tiles.merge(room.get_passable_tiles(), true)
		_impassable_tiles.merge(room.get_impassable_tiles(), true)
		
		var room_tiles: Dictionary = room.get_all_tiles()
		for tile_key in room_tiles:
			$TileContainer.add_child(room_tiles[tile_key])

func add_tile(tile: Tile):
	var key = tile.coordinate.string
	if _all_tiles.has(key):
		
		# Check if the tile is in a room, and if so, register it with the room
		var tile_room = get_room_by_tile(tile)
		if tile_room != null:
			tile_room.add_tile(tile)
			
		# Clear existing tile
		_all_tiles[key].queue_free()
		if tile.terrain.impassable:
			_impassable_tiles[key] = null
		else:
			_passable_tiles[key] = null
			
	# Add new tile to the dictionarties
	_all_tiles[key] = tile
	if tile.terrain.impassable:
		_impassable_tiles[key] = tile
	else:
		_passable_tiles[key] = tile
	
	add_child(tile)

func build_dungeon(size: int):
	clear_dungeon()
	_tile_maker.build_dungeon(size)

func clear_dungeon():
	for key in _all_tiles:
		_all_tiles[key].queue_free()
		
	_all_tiles.clear()
	_passable_tiles.clear()
	_impassable_tiles.clear()

	_rooms.clear()

func get_any_passable_tile():
	var tile_key = _passable_tiles.keys().pick_random()
	return _passable_tiles[tile_key]
	
func get_any_impassable_tile():
	var tile_key = _impassable_tiles.keys().pick_random()
	return _impassable_tiles[tile_key]
	
func get_any_tile():
	var tile_key = _all_tiles.keys().pick_random()
	return _all_tiles[tile_key]
	
func get_room_by_tile(tile: Tile) -> Room:
	### Returns a Room object if the requested Tile is in any Room, otherwise returns null. 
	for room in _rooms:
		var room_tiles = room.get_all_tiles()
		if room_tiles.get(tile.coordinate.string) != null:
			return room
	return null
	
func get_rooms() -> Array:
	return _rooms
	
func get_tile_from_coordinate(coordinate: Coordinate) -> Tile:
	return _all_tiles.get(coordinate.string)
	
func highlight_rooms():
	assert(len(_rooms) > 0, "Tried to highlight rooms, but none are stored")
	for room: Room in _rooms:
		var room_color = Color(randf(), randf(), randf())
		var tiles: Dictionary = room.get_all_tiles()
		for tile_key in tiles:
			var tile: Tile = tiles[tile_key]
			tile.sprite.modulate = room_color

func _test_links():
	assert(_tile_maker != null)
	
func _ready():
	_test_links()
