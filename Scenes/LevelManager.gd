class_name LevelManager
extends Node

var _all_tiles: Dictionary = {}
var _passable_tiles: Dictionary = {}
var _impassable_tiles: Dictionary = {}

var _rooms: Array = []

func add_room(room: Room):
	if room not in _rooms:
		_rooms.append(room)
		_all_tiles.merge(room.get_all_tiles(), true) # Overwrite any existing
		_passable_tiles.merge(room.get_passable_tiles(), true)
		_impassable_tiles.merge(room.get_impassable_tiles(), true)
		
		var room_tiles: Dictionary = room.get_all_tiles()
		for tile_key in room_tiles:
			$TileContainer.add_child(room_tiles[tile_key])

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
	
func get_tile_from_coordinate(coordinate: Coordinate):
	return _all_tiles[coordinate.string]
