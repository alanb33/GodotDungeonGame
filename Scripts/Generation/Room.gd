class_name Room

var _all_tiles: Dictionary = {}
var _passable_tiles: Dictionary = {}
var _impassable_tiles: Dictionary = {}

var pos: Vector2 = Vector2.ZERO
var size: Vector2 = Vector2.ZERO

func overlaps_with(other_room: Room):
	var w_range = range(pos.x, pos.x + size.x)
	var h_range = range(pos.y, pos.y + size.y)
	
	var other_w_range = range(other_room.pos.x, other_room.pos.x + other_room.size.x)
	var other_h_range = range(other_room.pos.y, other_room.pos.y + other_room.size.y)
	
	var has_w_conflict = false
	var has_h_conflict = false
	
	for w in other_w_range:
		if w_range.has(w):
			has_w_conflict = true
			break
			
	for h in other_h_range:
		if h_range.has(h):
			has_h_conflict = true
			break
			
	if has_w_conflict and has_h_conflict:
		return true
	else:
		return false

func merge_tiles(incoming_tiles: Dictionary):
	# true to overwrite
	_all_tiles.merge(incoming_tiles, true)
	
	for key in _all_tiles:
		var tile = _all_tiles[key]
		if tile.terrain.impassable:
			_impassable_tiles[key] = tile
		else:
			_passable_tiles[key] = tile
			
	assert(len(_passable_tiles.keys()) + len(_impassable_tiles.keys()) > 0, "Room was created but had no passable or impassable tiles")
			
func get_random_passable_tile():
	return _passable_tiles[_passable_tiles.keys().pick_random()]
	
func get_random_impassable_tile():
	return _impassable_tiles[_impassable_tiles.keys().pick_random()]

func get_all_tiles():
	return _all_tiles
	
func get_passable_tiles():
	return _passable_tiles

func get_impassable_tiles():
	return _impassable_tiles
