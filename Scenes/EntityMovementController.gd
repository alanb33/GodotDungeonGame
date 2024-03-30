class_name EntityMovementController
extends Node

@export var _entity_manager: EntityManager
@export var _tile_manager: TileManager

func _connect_em_signals():
	_entity_manager.entity_move_request.connect(_on_entity_move_request)

func _on_entity_move_request(entity: Entity, dir: MoveTypes.Dir):
	assert(entity.tile_pos != "X-X", entity.entity_name + " tried to move, but initial position was never set")
	print("Move request from " + str(entity.entity_name) + " received to " + MoveTypes.dir_str(dir))
	
	var entity_tile = _tile_manager.get_tile(entity.tile_pos)
	var new_dest = entity_tile.grid_position
		
	match dir:
		MoveTypes.Dir.UP:
			new_dest.y -= 1
		MoveTypes.Dir.DOWN:
			new_dest.y += 1
		MoveTypes.Dir.LEFT:
			new_dest.x -= 1
		MoveTypes.Dir.RIGHT:
			new_dest.x += 1
		MoveTypes.Dir.RANDOM:
			new_dest = _tile_manager.get_random_passable_tile().grid_position
		_:
			print("Move type not implemented")
			
	var dest_tile: Tile = _tile_manager.get_tile_from_grid_position(new_dest)
	if dest_tile == null:
		print("Requested destination tile is not initialized; canceling move")
	else:
		if dest_tile.terrain.impassable:
			print("You bump against the wall!")
		else:
			entity.tile_pos = dest_tile.grid_position_as_coordinates()
			entity.position = dest_tile.position
		
func _test_links():
	assert(_entity_manager != null, "EMC has a null EM link")
	assert(_tile_manager != null, "EMC has a null TM link")

func _ready():
	_test_links()
	_connect_em_signals()
