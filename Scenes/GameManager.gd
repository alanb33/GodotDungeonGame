extends Node

@export var _tile_maker: TileMaker
@export var _entity_manager: EntityManager
@export var _level_manager: LevelManager

const DUNGEON_ROOMS = 8

func _connect_signals():
	_tile_maker.dungeon_built.connect(_on_dungeon_built)
	_level_manager.request_player_vision_update.connect(_on_request_player_vision_update)
	_level_manager.request_player_position.connect(_on_request_player_position)

func _build_dungeon():
	_level_manager.build_dungeon(DUNGEON_ROOMS)
	
func _on_dungeon_built():
	_entity_manager.place_player()
	_entity_manager.place_enemy()
	_level_manager.do_dungeon_built_tasks()
	
func _on_request_player_position():
	_level_manager.receive_player_position(_entity_manager._player.coordinate)
	
func _on_request_player_vision_update():
	_entity_manager.update_player_vision()
	
func _test_links():
	assert(_tile_maker != null)
	assert(_entity_manager != null)
	assert(_level_manager != null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()
	_connect_signals()
	_build_dungeon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_home"):
		_build_dungeon()
