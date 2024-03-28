class_name TileMaker
extends Node

signal dungeon_built

@export var _entity_manager: EntityManager
@export var _tile_manager: TileManager

var _tile_floor_scene: PackedScene = preload("res://Scenes/Terrain/TileFloor.tscn")
var _tile_wall_scene: PackedScene = preload("res://Scenes/Terrain/TileWall.tscn")

var _tile_dict = {}

func build_room(x, y, width, height):
	assert(_tile_floor_scene.can_instantiate(), "Cannot instantiate Floor Scene")
	assert(_tile_wall_scene.can_instantiate(), "Cannot instantiate Wall scene")
	
	const MIN_WIDTH = 3
	const MIN_HEIGHT = 3
	
	assert(x >= 0, "Starting x must be 0 or greater")
	assert(y >= 0, "Starting y must be 0 or greater")
	assert(width >= MIN_WIDTH, "Room width must be >= " + str(MIN_WIDTH) + " (Received " + str(width) + ")")
	assert(height >= MIN_HEIGHT, "Room height must be >= " + str(MIN_HEIGHT) + " (Received " + str(height) + ")")
	
	for row in height:
		for col in width:
			var tile = null
			if row == 0 || row == height - 1 || col == 0 || col == width - 1:
				tile = _tile_wall_scene.instantiate()
			else:
				tile = _tile_floor_scene.instantiate()
			_tile_manager.add_tile(tile)
			tile.grid_position = Vector2(x + col, y + row)
			tile.resize()
			
			var tile_key = str(col + x) + "-" + str(row + y)
			_tile_dict[tile_key] = tile
			
	_tile_manager.merge_tiles(_tile_dict)
	
	var room = Room.new()
	room.merge_tiles(_tile_dict)
	_tile_manager.add_room(room)

func build_dungeon():
	#build_room(1, 1, 3, 3)
	build_room(10, 2, 5, 5)
	dungeon_built.emit()
