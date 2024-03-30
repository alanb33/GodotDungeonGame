class_name MoveTypes

enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	RANDOM_NEAR
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
		_:
			return "bad_dest"
