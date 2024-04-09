class_name FeatureDoor
extends Feature

enum State {
	Open,
	Closed
}

var _closed_texture: Texture = preload("res://Sprites/Door_Closed.png")
var _open_texture: Texture = preload("res://Sprites/Door_Open.png")

var state = FeatureDoor.State.Closed

var _door_neighbors = {}

func add_neighbor_dictionary(neighbor_dictionary: Dictionary) -> void:
	_door_neighbors.merge(neighbor_dictionary)

func close():
	_do_adjacency_close()
	
func open():
	_do_adjacency_open()
	
func _do_close_tasks():
	$Sprite2D.texture = _closed_texture
	blocking_contact = true
	state = FeatureDoor.State.Closed
	transparent = false
	
func _do_open_tasks():
	$Sprite2D.texture = _open_texture
	blocking_contact = false
	state = FeatureDoor.State.Open
	transparent = true
	
func _do_adjacency_close():
	for tile_key in _door_neighbors:
		var neighbor_door: FeatureDoor = _door_neighbors[tile_key].feature
		neighbor_door.adjacency_close()
	
func _do_adjacency_open():
	for tile_key in _door_neighbors:
		var neighbor_door: FeatureDoor = _door_neighbors[tile_key].feature
		neighbor_door.adjacency_open()
	
func adjacency_close():
	_do_close_tasks()
	
func adjacency_open():
	_do_open_tasks()
	
func do_entity_contact():
	if state == FeatureDoor.State.Closed:
		open()
	
func _prepare_data():
	type = Feature.Type.Door
	
func _prepare_sprite():
	# TODO: Turn the base Feature into a scene so we don't need to instantiate in every child.
	_sprite = $Sprite2D
	assert(_sprite != null, "FeatureDoor tried to work with a null Sprite")
	resize()
	
func _init():
	_prepare_data()
	
func _ready():
	_prepare_sprite()
	close()
