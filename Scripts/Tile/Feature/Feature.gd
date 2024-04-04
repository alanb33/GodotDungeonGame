class_name Feature
extends Node2D

@export var transparent = false
@export var blocking_contact = false

var _sprite = null
var sprite: Sprite2D:
	get:
		return _sprite
	set(value):
		_sprite = value

func do_entity_contact():
	assert(false, "Base Feature not implemented error")

func resize():
	# Base size is 32x32.
	sprite.scale.x = TileInfo.CURRENT_DIMENSIONS.x / TileInfo.BASE_DIMENSIONS.x
	sprite.scale.y = TileInfo.CURRENT_DIMENSIONS.y / TileInfo.BASE_DIMENSIONS.y

func _prepare_sprite():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
