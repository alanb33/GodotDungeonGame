class_name Coordinate

var _string: String = "X-X"
var _vector2: Vector2 = Vector2.ZERO

var string: String:
	get:
		return _string
	set(value):
		_string = value
		var coord_split = value.split("-")
		_vector2.x = int(coord_split[0])
		_vector2.y = int(coord_split[1])
		
var vector2: Vector2:
	get:
		return _vector2
	set(value):
		_vector2 = value
		var coord_str = str(value.x) + "-" + str(value.y)
		_string = coord_str
		
static func get_equivalent_string(vector2: Vector2):
	return str(vector2.x) + "-" + str(vector2.y)
	
static func get_equivalent_vector2(coordinate_string: String):
	assert(TileUtil.check_coordinate_validity(coordinate_string), "Invalid coordinate string " + coordinate_string + " supplied")
	var coord_split: Array = coordinate_string.split("-")
	return Vector2(coord_split[0], coord_split[1])

func make_equal_to(other: Coordinate):
	### GDScript workaround for a lack of being able to write operator overloading
	_string = other.string
	_vector2 = other.vector2
