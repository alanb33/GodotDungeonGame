class_name TileMaker
extends Node2D

var _tile_floor_scene: PackedScene = preload("res://Scenes/Terrain/TileFloor.tscn")
var _tile_wall_scene: PackedScene = preload("res://Scenes/Terrain/TileWall.tscn")

var _tile_dict = {}

func build_room(x, y, width, height):
	assert(_tile_floor_scene.can_instantiate(), "Cannot instantiate Floor Scene")
	assert(_tile_wall_scene.can_instantiate(), "Cannot instantiate Wall scene")
	
	const MIN_WIDTH = 3
	const MIN_HEIGHT = 3
	
	assert(x >= 0, "Starting column must be 0 or greater")
	assert(y >= 0, "Starting row must be 0 or greater")
	assert(width >= MIN_WIDTH, "Room width must be >= " + str(MIN_WIDTH) + " (Received " + str(width) + ")")
	assert(height >= MIN_HEIGHT, "Room height must be >= " + str(MIN_HEIGHT) + " (Received " + str(height) + ")")
	
	for row in height:
		for col in width:
			var tile = null
			print("Row/Col " + str(row) + "/" + str(col))
			if row == 0 || row == height - 1 || col == 0 || col == width - 1:
				tile = _tile_wall_scene.instantiate()
				print("Wall chosen")
			else:
				tile = _tile_floor_scene.instantiate()
				print("Floor chosen")
			add_child(tile)
			tile.grid_position = Vector2(x + col, y + row)
			tile.resize()
			
			var tile_key = str(row + y) + "-" + str(col + x)
			_tile_dict[tile_key] = tile

func _ready():
	build_room(1, 1, 3, 3)
	build_room(10, 2, 5, 5)
