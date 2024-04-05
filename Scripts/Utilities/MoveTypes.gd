class_name MoveTypes

enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NW,
	NE,
	SE,
	SW,
	RANDOM,
	RANDOM_NEAR,
	RANDOM_ROOM,
	NONE,
}

static func dir_str(dir: MoveTypes.Dir):
	match dir:
		MoveTypes.Dir.UP:
			return "up"
		MoveTypes.Dir.DOWN:
			return "down"
		MoveTypes.Dir.LEFT:
			return "left"
		MoveTypes.Dir.RIGHT:
			return "right"
		MoveTypes.Dir.RANDOM_NEAR:
			return "random_near"
		MoveTypes.Dir.RANDOM_ROOM:
			return "random_room"
		_:
			return "bad_dest"
