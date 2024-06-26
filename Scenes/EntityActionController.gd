class_name EntityActionController
extends Node

@export var _entity_manager: EntityManager
@export var _level_manager: LevelManager

var _grid_selector_scene: PackedScene = preload("res://Scenes/Util/GridSelector.tscn")
var _awaiting_input := false

var _active_selector_grid = []

signal _request_completed(entity: Entity)
signal _input_dir(dir: TileUtil.Dir)

func _input(event):
	if _awaiting_input:
		if Input.is_action_just_pressed("ui_left"):
			_input_dir.emit(TileUtil.Dir.W)
		if Input.is_action_just_pressed("ui_right"):
			_input_dir.emit(TileUtil.Dir.E)
		if Input.is_action_just_pressed("ui_up"):
			_input_dir.emit(TileUtil.Dir.N)
		if Input.is_action_just_pressed("ui_down"):
			_input_dir.emit(TileUtil.Dir.S)
		if Input.is_action_just_pressed("ui_nw"):
			_input_dir.emit(TileUtil.Dir.NW)
		if Input.is_action_just_pressed("ui_ne"):
			_input_dir.emit(TileUtil.Dir.NE)
		if Input.is_action_just_pressed("ui_se"):
			_input_dir.emit(TileUtil.Dir.SE)
		if Input.is_action_just_pressed("ui_sw"):
			_input_dir.emit(TileUtil.Dir.SW)

func _connect_signals():
	_entity_manager.entity_action_request.connect(_on_entity_action_request)
	_request_completed.connect(_on_entity_request_completed)

func _free_selector_grid() -> void:
	for grid_square in _active_selector_grid:
		grid_square.queue_free()
	_active_selector_grid.clear()

func _get_tile_selection(entity: Entity) -> Tile:
	_spawn_selector_grid_around(entity)
	_awaiting_input = true
	var selection_dir = await _input_dir
	_awaiting_input = false
	var selection_coord = Coordinate.new()
	var surrounding_coords = TileUtil.get_surrounding_tile_vector2_dictionary(entity.coordinate)
	selection_coord.vector2 = surrounding_coords[selection_dir]
	
	return _level_manager.get_tile_from_coordinate(selection_coord)

func _handle_close_action(entity: Entity):
	# Spawn a grid of sprites around the player to show a highlight of what might be selected.
	# Then, wait for a directional input.
	# If the selected tile has a Door feature and it is open, close it!
	
	# The Grid Selectors are not actually on the grid, they just surround the Entity's tile.
	# Only worry about showing this for the Player, I'll do some Entity-specific code later.
	
	if entity.player_controlled:
		var tile_to_close = await _get_tile_selection(entity)
		if tile_to_close != null:
			var feature = tile_to_close.feature
			if feature != null:
				if feature is FeatureDoor:
					var door = feature
					if door.state == FeatureDoor.State.Open:
						door.close()
						print("You close the door.")
					else:
						print("That door is already closed.")
				else:
					print("Nothing to close there.")
			else:
				print("Nothing to close there.")
		else:
			print("Nothing to close there.")
			
		_release_player_action(entity)
	
	_request_completed.emit(entity)
		
func _handle_open_action(entity: Entity):
	
	if entity.player_controlled:
		var tile_to_open = await _get_tile_selection(entity)
		
		if tile_to_open != null:
			var feature = tile_to_open.feature
			if feature != null:
				if feature is FeatureDoor:
					var door: FeatureDoor = tile_to_open.feature
					if door.state == FeatureDoor.State.Closed:
						door.open()
						print("You open the door.")
					else:
						print("The door is already open.")
				else:
					print("You cannot open that.")
			else:
				print("Nothing there to open.")
		else:
			print("Nothing there to open.")
			
		_release_player_action(entity)
	
	_request_completed.emit(entity)
		
func _handle_open_all_action(entity: Entity):
	var entity_tile = _level_manager.get_tile_from_coordinate(entity.coordinate)
	var entity_room = _level_manager.get_room_by_tile(entity_tile)
	if entity_room == null:
		# Entity is not in a room. Open all doors
		var all_door_tiles = _level_manager.get_features_of_type(Feature.Type.Door)
		for tile in all_door_tiles:
			var door = tile.feature
			door.open()
	else:
		# Entity is in a room. Open the room's doors
		var room_door_tiles = _level_manager.get_features_of_type_in_room_from_tile(Feature.Type.Door, entity_tile)
		for tile in room_door_tiles:
			var door = tile.feature
			door.open()
				
	_request_completed.emit(entity)
				
func _on_entity_action_request(entity: Entity, action: ActionTypes.Action):
	match action:
		ActionTypes.Action.PRINT_DEBUG:
			print("ActionType Debug from " + entity.entity_name + ": PRINT DEBUG")
		ActionTypes.Action.ACTION_CLOSE:
			_handle_close_action(entity)
		ActionTypes.Action.ACTION_OPEN:
			_handle_open_action(entity)
		ActionTypes.Action.ACTION_OPEN_ALL:
			_handle_open_all_action(entity)
		_:
			assert(false, "Undefined ActionType received")
	
func _on_entity_request_completed(entity: Entity):
	if entity.player_controlled:
		_release_player_action(entity)
		entity.update_vision()
	entity.complete_request()

func _test_links():
	assert(_entity_manager != null, "EAC has null EM")
	assert(_level_manager != null, "EAC has null LM")
	
	assert(_grid_selector_scene.can_instantiate(), "EAC cannot instantiate GridSelector scene")
	
func _release_player_action(player: Entity):
	_free_selector_grid()
	player.movement_locked = false
	
func _spawn_selector_grid_around(entity: Entity) -> void:
	# Spawn the selector grid around the Entity, and then return it to the caller so they can
	# despawn it later. We'll also 
	
	var surrounding_directions: Dictionary = TileUtil.get_surrounding_tile_vector2_dictionary(entity.coordinate)
	
	for dir_key in surrounding_directions.keys():
		var grid_selector = _grid_selector_scene.instantiate()
		add_child(grid_selector)
		grid_selector.position = surrounding_directions[dir_key] * TileInfo.CURRENT_DIMENSIONS
		_active_selector_grid.append(grid_selector)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()
	_connect_signals()
