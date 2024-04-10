class_name Tile
extends Node2D

### A Tile contains one Terrain, zero to many Items, and zero to one Entity.
### A Tile has its grid coordinates and its graphic known to it. Its Terrain
### determines its passability, transparency, and sprite.

var coordinate: Coordinate = Coordinate.new()

@export var detection_square: DetectionSquare

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
var items = []
var entity = null

var discovered := false
var within_sight := false

var _base_color: Color = Color(1, 1, 1)
var base_color: Color:
	get:
		return _base_color
	set(value):
		_base_color = value
		sprite.modulate = value
		if feature:
			if feature.sprite != null:
				feature.sprite.modulate = value

var _color: Color = _base_color
var color: Color:
	get:
		return _color
	set(value):
		_color = value
		sprite.modulate = value
		if feature:
			if feature.sprite != null:
				feature.sprite.modulate = value

func reset_color():
	color = base_color

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
	
func _test_links():
	assert(terrain != null, "Tile tried to initiate with a null terrain")
	assert(detection_square != null, "Tile tried to initiate with a null detection square")
	
func _link_detection_square():
	detection_square.tile = self
	
func _ready():
	_test_links()
	_link_detection_square()
