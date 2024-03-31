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
