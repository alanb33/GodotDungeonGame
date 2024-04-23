class_name LevelManager
extends Node

@export var _tile_maker: TileMaker = null

signal request_player_vision_update

signal request_player_position
signal complete_player_position_request(player_tile: Tile)

var _all_tiles: Dictionary = {}
var _passable_tiles: Dictionary = {}
var _impassable_tiles: Dictionary = {}

var _feature_tiles = {}

var _rooms: Array = []

var _astar: AStar2D = null
var _astar_counter := 0
var _astar_id_dict := {}

func do_dungeon_built_tasks():
	_build_astar_grid()
	_highlight_rooms()
	_hide_tiles()
	_do_debug_tasks()

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
	
func _hide_tiles():
	for tile_key in _all_tiles:
		_all_tiles[tile_key].visible = false
	
func connect_adjacent_doors(tile: Tile):
	
	assert(tile.feature != null, "Tried to connect adjacent doors for a featureless tile at " + tile.coordinate.string)
	assert(tile.feature is FeatureDoor, "Tried to connect adjacent doors to a non-door tile at " + tile.coordinate.string)
	
	var door_tiles = {}
	
	door_tiles[tile.coordinate.string] = tile
	
	door_tiles.merge(_search_adjacent_tiles_for_doors_from(tile, door_tiles))
	
	for tile_key in door_tiles:
		var door_tile = door_tiles[tile_key]
		var door: FeatureDoor = door_tile.feature
		door.add_neighbor_dictionary(door_tiles)
	
func _search_adjacent_tiles_for_doors_from(tile: Tile, door_tiles: Dictionary) -> Dictionary:
	
	# The Tile we're searching from should not be included.
	# We just want to find any doors surrounding it.
	
	var adjacent_tiles = get_tiles_adjacent_to(tile)
	
	for tile_key in adjacent_tiles:
		var adjacent_tile = adjacent_tiles[tile_key]
		if adjacent_tile != null:
			assert(adjacent_tile is Tile, "adjacent_tile is not Tile but type " + type_string(typeof(adjacent_tile)))
			if door_tiles.get(adjacent_tile.coordinate.string):
				continue
			else:
				if adjacent_tile.feature != null:
					if adjacent_tile.feature is FeatureDoor:
						door_tiles[adjacent_tile.coordinate.string] = adjacent_tile
						_search_adjacent_tiles_for_doors_from(adjacent_tile, door_tiles)
					
	return door_tiles
	
## Test documentation outside
func get_tiles_adjacent_to(tile: Tile):
	## Test documentation inside
	var adjacent_tiles = {}
	var tiles_v2 = TileUtil.get_surrounding_tile_vector2_dictionary(tile.coordinate)
	for tile_vector_key in tiles_v2:
		var coord_string = Coordinate.get_equivalent_string(tiles_v2[tile_vector_key])
		adjacent_tiles[coord_string] = get_tile_from_coordinate_string(coord_string)
	return adjacent_tiles
	
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
	
func get_tile_from_coordinate_string(coord_string: String) -> Tile:
	TileUtil.check_coordinate_validity(coord_string)
	return _all_tiles.get(coord_string)
	
func get_tile_vector_towards_player(from_tile: Tile):
	assert(_astar != null, "Tried to get tile towards player, but A* system is null")
	request_player_position.emit()
	var player_tile: Tile = await complete_player_position_request
	var source_id = from_tile.astar_id
	var player_id = player_tile.astar_id

	var path = _astar.get_point_path(source_id, player_id)
	print("Path: " + str(path))
	var next_tile_v2: Vector2 = path[0]
	var next_tile_coord_string = TileUtil.vector_to_coordinate_string(next_tile_v2.x, next_tile_v2.y)
	var next_tile = get_tile_from_coordinate_string(next_tile_coord_string)
	
	return next_tile.coordinate.vector2
	
func receive_player_position(player_coord: Coordinate):
	var player_tile = get_tile_from_coordinate(player_coord)
	complete_player_position_request.emit(player_tile)
	
func _highlight_rooms():
	assert(len(_rooms) > 0, "Tried to highlight rooms, but none are stored")
	for room: Room in _rooms:
		var room_color = Color(randf(), randf(), randf())
		var tiles: Dictionary = room.get_all_tiles()
		for tile_key in tiles:
			var tile: Tile = tiles[tile_key]
			tile.base_color = room_color

func _test_links():
	assert(_tile_maker != null)
	
func _do_debug_tasks():
	if GameConfig.DEBUG_REVEAL_ALL_TILES:
		_reveal_all_tiles()
	
func _reveal_all_tiles():
	for tile_coord in _all_tiles:
		var tile = _all_tiles[tile_coord]
		tile.reveal()
	request_player_vision_update.emit()
	
func _clear_existing_astar():
	if _astar != null:
		for key in _all_tiles:
			var tile: Tile = _all_tiles[key]
			tile.astar_id = -1
		_astar.clear()
		_astar_counter = 0
		_astar_id_dict.clear()
	
func _build_astar_grid():
	### Construct an A* grid from all connected tiles.
	_clear_existing_astar()
	_astar = AStar2D.new()
	
	var source_tile: Tile = get_any_passable_tile()
	
	_build_astar_grid_from(source_tile)
	
	print("Astar buil complete! Final counter: " + str(_astar_counter))
	
func _build_astar_grid_from(source_tile: Tile):
	### This recursive function will propagate to all passable tiles.
	
	if source_tile.astar_id != -1:
		# The 'unconnected' state is -1.
		_astar.add_point(_astar_counter, source_tile.coordinate.vector2)
		source_tile.astar_id = _astar_counter
		_astar_id_dict[_astar_counter] = source_tile
		_astar_counter += 1
		
	# Now get surrounding passable tiles.
	
	var new_tiles = []
	
	var surrounding_tile_coords_dict = get_tiles_adjacent_to(source_tile)
	for tile_coord in surrounding_tile_coords_dict:
		var neighbor_tile: Tile = get_tile_from_coordinate_string(tile_coord)
		if neighbor_tile != null:
			if neighbor_tile.terrain.impassable:
				# Skip impassable tiles
				continue
			else:
				if neighbor_tile.astar_id == -1:
					# Unconnected tile, let's connect it to us!
					_astar.add_point(_astar_counter, neighbor_tile.coordinate.vector2)
					neighbor_tile.astar_id = _astar_counter
					_astar_id_dict[_astar_counter] = neighbor_tile
					_astar_counter += 1
					_astar.connect_points(source_tile.astar_id, neighbor_tile.astar_id)
					new_tiles.append(neighbor_tile)
				else:
					# This is a registered tile, are we connected to it?
					if _astar.are_points_connected(source_tile.astar_id, neighbor_tile.astar_id):
						# We are, ignore it!
						continue
					else:
						# We aren't, link up!
						_astar.connect_points(source_tile.astar_id, neighbor_tile.astar_id)
			
	# Now we're linked to the neighbors, so continue from the neighbor tiles!
	for tile in new_tiles:
		_build_astar_grid_from(tile)
	
	
func _ready():
	_test_links()
