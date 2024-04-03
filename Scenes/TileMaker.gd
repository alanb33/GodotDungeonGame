class_name TileMaker
extends Node

signal dungeon_built

@export var _entity_manager: EntityManager
@export var _level_manager: LevelManager

var _tile_floor_scene: PackedScene = preload("res://Scenes/Terrain/TileFloor.tscn")
var _tile_wall_scene: PackedScene = preload("res://Scenes/Terrain/TileWall.tscn")

func _assemble_room_candidate():

	var _tile_dict = {}
	
	var width = randi_range(DungeonConstants.MIN_ROOM_SIZE, DungeonConstants.MAX_ROOM_SIZE)
	var height = randi_range(DungeonConstants.MIN_ROOM_SIZE, DungeonConstants.MAX_ROOM_SIZE)
	var x = randi_range(0, DungeonConstants.DUNGEON_WIDTH - width)
	var y = randi_range(0, DungeonConstants.DUNGEON_HEIGHT - height)
	
	assert(x >= 0, "Starting x must be 0 or greater")
	assert(y >= 0, "Starting y must be 0 or greater")
	assert(width >= DungeonConstants.MIN_ROOM_SIZE, "Room width must be >= " + str(DungeonConstants.MIN_ROOM_SIZE) + " (Received " + str(width) + ")")
	assert(height >= DungeonConstants.MIN_ROOM_SIZE, "Room height must be >= " + str(DungeonConstants.MIN_ROOM_SIZE) + " (Received " + str(height) + ")")
	
	for row in height:
		for col in width:
			var tile = null
			if row == 0 || row == height - 1 || col == 0 || col == width - 1:
				tile = _tile_wall_scene.instantiate()
			else:
				tile = _tile_floor_scene.instantiate()
			tile.coordinate.vector2 = Vector2(x + col, y + row)
			tile.resize()
			
			var tile_key = str(col + x) + "-" + str(row + y)
			_tile_dict[tile_key] = tile
	
	var room = Room.new()
	room.pos = Vector2(x, y)
	room.size = Vector2(width, height)
	room.merge_tiles(_tile_dict)
	
	return room
	
func build_hallways():
	
	var rooms = _level_manager.get_rooms()
	var number_of_hallways = len(rooms) - 1
	
	var hallway_tiles = {}
	
	for i in range(number_of_hallways):
		var start_room: Room = rooms[i]
		var dest_room: Room = rooms[i+1]
		var valid_proposal: Dictionary = _assemble_hallway_candidate(start_room, dest_room)
			
		for y in valid_proposal["y_range"]:
			var hallway_tile: Tile = _tile_floor_scene.instantiate()
			hallway_tile.coordinate.vector2 = Vector2(valid_proposal["start_tile"].coordinate.vector2.x, y)
			hallway_tile.resize()
			hallway_tiles[hallway_tile.coordinate.string] = hallway_tile

		for x in valid_proposal["x_range"]:
			var hallway_tile: Tile = _tile_floor_scene.instantiate()
			hallway_tile.coordinate.vector2 = Vector2(x, valid_proposal["dest_tile"].coordinate.vector2.y)
			hallway_tile.resize()
			hallway_tiles[hallway_tile.coordinate.string] = hallway_tile
			
	for tile_key in hallway_tiles:
		_level_manager.add_tile(hallway_tiles[tile_key])

func _assemble_hallway_candidate(start_room: Room, dest_room: Room) -> Dictionary:
	# This code is not the best. I am unhappy with returning a dictionary of arbitrary values.
	# What is a better way to do it?
	
	var valid_proposal: Dictionary = {}
	
	while true:
		
		var tile_proposal: Dictionary = {}
		var start_tile: Tile = start_room.get_random_passable_tile()
		var dest_tile: Tile = dest_room.get_random_passable_tile()
		
		var y_step = 1
		var y_diff = start_tile.coordinate.vector2.y - dest_tile.coordinate.vector2.y
		if y_diff > 0:
			y_step = -1
			
		var proposed_y_range = range(start_tile.coordinate.vector2.y, dest_tile.coordinate.vector2.y, y_step)
		for y in proposed_y_range:
			var tile_coord = str(start_tile.coordinate.vector2.x) + "-" + str(y)
			tile_proposal[tile_coord] = true
			
		var x_step = 1
		var x_diff = start_tile.coordinate.vector2.x - dest_tile.coordinate.vector2.x
		if x_diff > 0:
			x_step = -1
			
		var proposed_x_range = range(start_tile.coordinate.vector2.x, dest_tile.coordinate.vector2.x, x_step)
		for x in proposed_x_range:
			var tile_coord = str(x) + "-" + str(dest_tile.coordinate.vector2.y)
			tile_proposal[tile_coord] = true
			
		if _valid_hallway(tile_proposal):
			valid_proposal["y_range"] = proposed_y_range
			valid_proposal["x_range"] = proposed_x_range
			valid_proposal["start_tile"] = start_tile
			valid_proposal["dest_tile"] = dest_tile
			break
			
	return valid_proposal

func _valid_hallway(tile_proposal: Dictionary) -> bool:
	var dungeon_rooms: Array = _level_manager.get_rooms()
	for room in dungeon_rooms:
		var intersecting_tiles = []
		var wall_intersection_count = 0
		for coordinate in tile_proposal.keys():
			var tile: Tile = room.get_tile_by_coordinate_string(coordinate)
			if tile != null:
				if room.is_coordinate_string_in_corner(tile.coordinate.string):
					print("Rejecting bad hallway: corner intersection")
					return false
				else:
					if tile.terrain.impassable:
						wall_intersection_count += 1
						intersecting_tiles.append(tile)
		
		if wall_intersection_count > 2:
			print("Rejecting bad hallway: Too many wall intersections")
			return false
			
		elif wall_intersection_count == 2:
			var tile_a: Tile = intersecting_tiles[0]
			var tile_b: Tile = intersecting_tiles[1]
			
			var adjacency_error := false
			if tile_a.coordinate.vector2.x == tile_b.coordinate.vector2.x:
				if abs(tile_a.coordinate.vector2.y - tile_b.coordinate.vector2.y) == 1:
					adjacency_error = true
					
			if tile_a.coordinate.vector2.y == tile_b.coordinate.vector2.x:
				if abs(tile_a.coordinate.vector2.x - tile_b.coordinate.vector2.x) == 1:
					adjacency_error = true
					
			if adjacency_error:
				print("Rejecting bad hallway: Corner adjacency error")
				return false
				
	return true

func build_room():
	
	while true:
		var room: Room = _assemble_room_candidate()
		if _level_manager.valid_room(room):
			_level_manager.add_room(room)
			break

func build_dungeon(size: int):
	
	for _i in range(size):
		build_room()
		
	build_hallways()
		
	dungeon_built.emit()

func _test_links():
	assert(_tile_floor_scene.can_instantiate(), "Cannot instantiate Floor Scene")
	assert(_tile_wall_scene.can_instantiate(), "Cannot instantiate Wall scene")

func _ready():
	_test_links()

