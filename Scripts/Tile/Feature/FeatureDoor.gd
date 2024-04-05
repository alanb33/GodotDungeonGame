class_name FeatureDoor
extends Feature

var _closed_texture: Texture = preload("res://Sprites/Door_Closed.png")
var _open_texture: Texture = preload("res://Sprites/Door_Open.png")

var closed := true

func close():
	print("Closing...?")
	$Sprite2D.texture = _closed_texture
	blocking_contact = true
	closed = true
	transparent = false
	print("Closed...?")
	print(closed)
	
func open():
	$Sprite2D.texture = _open_texture
	blocking_contact = false
	closed = false
	transparent = true

func do_entity_contact():
	if closed:
		open()
	
func _prepare_sprite():
	# TODO: Turn the base Feature into a scene so we don't need to instantiate in every child.
	_sprite = $Sprite2D
	print(str($Sprite2D))
	assert(_sprite != null, "FeatureDoor tried to work with a null Sprite")
	resize()
	
func _ready():
	_prepare_sprite()
	close()
