class_name Tile
extends Node2D

### A Tile contains one Terrain, zero to many Items, and zero to one Entity.
### A Tile has its grid coordinates and its graphic known to it. Its Terrain
### determines its passability, transparency, and sprite.

var coordinate: Coordinate = Coordinate.new()

@export var terrain: Terrain
var items = []
var entity = null

var sprite: Sprite2D:
	get:
		return terrain.sprite
	set(value):
		terrain.sprite = value

func resize():
	terrain.resize()
	position.x = TileInfo.CURRENT_DIMENSIONS.x * (coordinate.vector2.x)
	position.y = TileInfo.CURRENT_DIMENSIONS.y * (coordinate.vector2.y)
