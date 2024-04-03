class_name TileInfo

const BASE_DIMENSIONS: Vector2 = Vector2(32, 32)
static var CURRENT_DIMENSIONS: Vector2 = BASE_DIMENSIONS

static func vector_to_coordinate_string(x: int, y: int):
	return str(x) + "-" + str(y)
