class_name Room

var _all_tiles: Dictionary = {}
var _passable: Array = []
var _impassable: Array = []

func merge_tiles(incoming_tiles: Dictionary):
	# true to overwrite
	_all_tiles.merge(incoming_tiles, true)
	
	for key in _all_tiles:
		var tile = _all_tiles[key]
		if tile.terrain.impassable:
			_impassable.append(tile)
		else:
			_passable.append(tile)
			
	assert(len(_passable) + len(_impassable) > 0, "Room was created but had no passable or impassable tiles")
			
func get_random_passable_tile():
	return _passable.pick_random()
	
func get_random_impassable_tile():
	return _impassable.pick_random()
