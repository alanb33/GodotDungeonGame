class_name TileUtil

enum Dir {
	NW,
	N,
	NE,
	E,
	SE,
	S,
	SW,
	W,
	NONE,
}

const _valid_coordinate_regex = "^\\d+-\\d+$"

static func check_coordinate_validity(coordinate_string: String) -> bool:
	var regex = RegEx.new()
	regex.compile(_valid_coordinate_regex)
	if regex.search(coordinate_string):
		return true
	assert(false, "Received bad coordinate string: " + coordinate_string)
	return false

static func get_surrounding_tile_vector2_dictionary(origin: Coordinate) -> Dictionary:
	
	var dir_dict = {
		Dir.NW: Vector2(origin.vector2.x - 1, origin.vector2.y - 1),
		Dir.N: Vector2(origin.vector2.x, origin.vector2.y - 1),
		Dir.NE: Vector2(origin.vector2.x + 1, origin.vector2.y - 1),
		Dir.E: Vector2(origin.vector2.x + 1, origin.vector2.y),
		Dir.SE: Vector2(origin.vector2.x + 1, origin.vector2.y + 1),
		Dir.S: Vector2(origin.vector2.x, origin.vector2.y + 1),
		Dir.SW: Vector2(origin.vector2.x - 1, origin.vector2.y + 1),
		Dir.W: Vector2(origin.vector2.x - 1, origin.vector2.y),
	}
	
	return dir_dict

static func vector_to_coordinate_string(x: int, y: int):
	return str(x) + "-" + str(y)
