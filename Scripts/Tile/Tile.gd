class_name Tile
extends Node2D

### A Tile contains one Terrain, zero to many Items, and zero to one Entity.
### A Tile has its grid coordinates and its graphic known to it. Its Terrain
### determines its passability, transparency, and sprite.

var grid_position: Vector2

@export var terrain: Terrain
var items = []
var entity = null

var sprite: Sprite2D:
	get:
		return terrain.sprite
	set(value):
		terrain.sprite = value

func grid_position_as_coordinates():
	return str(grid_position.x) + "-" + str(grid_position.y)

func resize():
	terrain.resize()
	position.x = TileInfo.CURRENT_DIMENSIONS.x * (grid_position.x)
	position.y = TileInfo.CURRENT_DIMENSIONS.y * (grid_position.y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
