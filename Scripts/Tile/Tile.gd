class_name Tile
extends Node2D

### A Tile contains one Terrain, zero to many Items, and zero to one Entity.
### A Tile has its grid coordinates and its graphic known to it. Its Terrain
### determines its passability, transparency, and sprite.

var coordinate: Coordinate = Coordinate.new()

@export var terrain: Terrain
var _feature: Feature = null
var feature: Feature:
	get:
		return _feature
	set(new_feature):
		assert(new_feature != null, "Tile tried to instantiate null feature")
		assert(new_feature is Feature, "New feature is not type FeatureDoor but " + str(typeof(new_feature)))
		if _feature != null:
			_feature.queue_free()
			_feature = null
		_feature = new_feature
		add_child(_feature)
		print(_feature.get_child_count())
var items = []
var entity = null

var sprite: Sprite2D:
	get:
		return terrain.sprite
	set(value):
		terrain.sprite = value

func resize():
	terrain.resize()
	if feature:
		feature.resize()
	position.x = TileInfo.CURRENT_DIMENSIONS.x * (coordinate.vector2.x)
	position.y = TileInfo.CURRENT_DIMENSIONS.y * (coordinate.vector2.y)
