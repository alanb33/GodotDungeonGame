class_name TileMaker
extends Node

signal dungeon_built

@export var _entity_manager: EntityManager
@export var _level_manager: LevelManager

var _tile_floor_scene: PackedScene = preload("res://Scenes/Terrain/TileFloor.tscn")
var _tile_wall_scene: PackedScene = preload("res://Scenes/Terrain/TileWall.tscn")

var _tile_dict = {}

func build_room():
	assert(_tile_floor_scene.can_instantiate(), "Cannot instantiate Floor Scene")
	assert(_tile_wall_scene.can_instantiate(), "Cannot instantiate Wall scene")
	
	var width = randi_range(DungeonConstants.MIN_ROOM_SIZE, DungeonConstants.MAX_ROOM_SIZE)
	var height = randi_range(DungeonConstants.MIN_ROOM_SIZE, DungeonConstants.MAX_ROOM_SIZE)
	var x = randi_range(0, DungeonConstants.DUNGEON_WIDTH - width)
	var y = randi_range(0, DungeonConstants.DUNGEON_HEIGHT - height)
	
	print("x/y/width/height = " + str(x) + "/" + str(y) + "/" + str(width) + "/" + str(height))
	
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
	_level_manager.add_room(room)

func build_dungeon():
	#build_room(1, 1, 3, 3)
	build_room()
	build_room()
	build_room()
	dungeon_built.emit()
