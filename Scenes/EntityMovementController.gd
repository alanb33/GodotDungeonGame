class_name EntityMovementController
extends Node

@export var _entity_manager: EntityManager
@export var _level_manager: LevelManager

func _connect_em_signals():
	_entity_manager.entity_move_request.connect(_on_entity_move_request)

func _on_entity_move_request(entity: Entity, dir: MoveTypes.Dir):
	assert(entity.coordinate.string != "X-X", entity.entity_name + " tried to move, but initial position was never set")
	
	var entity_tile = _level_manager.get_tile_from_coordinate(entity.coordinate)
	var new_dest_coord = Coordinate.new()
	new_dest_coord.make_equal_to(entity_tile.coordinate)
		
	match dir:
		MoveTypes.Dir.UP:
			new_dest_coord.vector2.y -= 1
		MoveTypes.Dir.DOWN:
			new_dest_coord.vector2.y += 1
		MoveTypes.Dir.LEFT:
			new_dest_coord.vector2.x -= 1
		MoveTypes.Dir.RIGHT:
			new_dest_coord.vector2.x += 1
		MoveTypes.Dir.NW:
			new_dest_coord.vector2.x -= 1
			new_dest_coord.vector2.y -= 1
		MoveTypes.Dir.NE:
			new_dest_coord.vector2.x += 1
			new_dest_coord.vector2.y -= 1
		MoveTypes.Dir.SE:
			new_dest_coord.vector2.x += 1
			new_dest_coord.vector2.y += 1
		MoveTypes.Dir.SW:
			new_dest_coord.vector2.x -= 1
			new_dest_coord.vector2.y += 1
		MoveTypes.Dir.RANDOM:
			new_dest_coord.make_equal_to(_level_manager.get_any_passable_tile().coordinate)
		_:
			print("Move type not implemented")
			
	var dest_tile: Tile = _level_manager.get_tile_from_coordinate(new_dest_coord)
	if dest_tile == null:
		print("You bump against the wall!")
	else:
		if dest_tile.terrain.impassable:
			print("You bump against the wall!")
		else:
			if dest_tile.feature:
				if not dest_tile.feature.blocking_contact:
					_move_entity(entity, dest_tile)
				dest_tile.feature.do_entity_contact()
				entity.update_vision()
			else:
				_move_entity(entity, dest_tile)
				
func _move_entity(entity: Entity, dest_tile: Tile):
	entity.coordinate.make_equal_to(dest_tile.coordinate)
	entity.position = dest_tile.position
	entity.update_vision()
		
func _test_links():
	assert(_entity_manager != null, "EMC has a null EM link")
	assert(_level_manager != null, "EMC has a null LM link")

func _ready():
	_test_links()
	_connect_em_signals()
