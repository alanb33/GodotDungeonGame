extends Node

@export var _tile_maker: TileMaker
@export var _entity_manager: EntityManager
@export var _level_manager: LevelManager

const DUNGEON_ROOMS = 8

func _connect_signals():
	_tile_maker.dungeon_built.connect(_on_dungeon_built)

func _build_dungeon():
	_level_manager.build_dungeon(DUNGEON_ROOMS)
	
func _on_dungeon_built():
	_entity_manager.place_player()
	_level_manager.highlight_rooms()
	
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
