class_name LevelManager
extends Node

@export var _tile_maker: TileMaker = null

var _all_tiles: Dictionary = {}
var _passable_tiles: Dictionary = {}
var _impassable_tiles: Dictionary = {}

var _rooms: Array = []

func valid_room(new_room: Room):
	for room in _rooms:
		if new_room.overlaps_with(room):
			print("Rejecting room overlap")
			return false
	return true

func add_room(room: Room):
	if room not in _rooms:
		_rooms.append(room)
		
		for key in room.get_all_tiles():
			if _all_tiles.get(key) != null:
				_all_tiles[key].queue_free()
				print("Preventing duplicate tile")
		
		_all_tiles.merge(room.get_all_tiles(), true) # Overwrite any existing
		_passable_tiles.merge(room.get_passable_tiles(), true)
		_impassable_tiles.merge(room.get_impassable_tiles(), true)
		
		var room_tiles: Dictionary = room.get_all_tiles()
		for tile_key in room_tiles:
			$TileContainer.add_child(room_tiles[tile_key])

func add_tile(tile: Tile):
	var coord = tile.coordinate.string
	if _all_tiles.has(coord):
		_all_tiles[coord].queue_free()
		if tile.terrain.impassable:
			_impassable_tiles[coord] = null
		else:
			_passable_tiles[coord] = null
			
	_all_tiles[coord] = tile
	if tile.terrain.impassable:
		_impassable_tiles[coord] = tile
	else:
		_passable_tiles[coord] = tile
	
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
	
func get_room_by_tile(tile: Tile):
	### Returns a Room object if the requested Tile is in any Room, otherwise returns null. 
	for room in _rooms:
		if room[tile.coordinate.string] != null:
			return room
	return null
	
func get_rooms() -> Array:
	return _rooms
	
func get_tile_from_coordinate(coordinate: Coordinate):
	return _all_tiles.get(coordinate.string)

func _test_links():
	assert(_tile_maker != null)
	
func _ready():
	_test_links()
