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
		var start_tile: Tile = start_room.get_random_passable_tile()
		var dest_tile: Tile = dest_room.get_random_passable_tile()
		
		var y_step = 1
		var y_diff = start_tile.coordinate.vector2.y - dest_tile.coordinate.vector2.y
		if y_diff > 0:
			y_step = -1
			
		print("y_diff: " + str(y_diff))
		print("range is: " + str(start_tile.coordinate.vector2.y) + " to " + str(dest_tile.coordinate.vector2.y) + " with a step of " + str(y_step))
			
		for y in range(start_tile.coordinate.vector2.y, dest_tile.coordinate.vector2.y, y_step):
			var hallway_tile: Tile = _tile_floor_scene.instantiate()
			hallway_tile.coordinate.vector2 = Vector2(start_tile.coordinate.vector2.x, y)
			hallway_tile.resize()
			print("y_diff instantiation at " + str(hallway_tile.coordinate.vector2))
			hallway_tiles[hallway_tile.coordinate.string] = hallway_tile
			
		var x_step = 1
		var x_diff = start_tile.coordinate.vector2.x - dest_tile.coordinate.vector2.x
		if x_diff > 0:
			x_step = -1
			
		print("x_diff: " + str(x_diff))
			
		for x in range(start_tile.coordinate.vector2.x, dest_tile.coordinate.vector2.x, x_step):
			
			var hallway_tile: Tile = _tile_floor_scene.instantiate()
			hallway_tile.coordinate.vector2 = Vector2(x, dest_tile.coordinate.vector2.y)
			hallway_tile.resize()
			print("x_diff instantiation at " + str(hallway_tile.coordinate.vector2))
			hallway_tiles[hallway_tile.coordinate.string] = hallway_tile
			
	for tile_key in hallway_tiles:
		_level_manager.add_tile(hallway_tiles[tile_key])

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

