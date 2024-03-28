extends Node

@export var _tile_maker: TileMaker
@export var _entity_manager: EntityManager
@export var _tile_manager: TileManager

func _connect_signals():
	_tile_maker.dungeon_built.connect(_on_dungeon_built)

func _build_dungeon():
	_tile_maker.build_dungeon()
	
func _on_dungeon_built():
	print("Dungeon built")
	_entity_manager.place_player()
	
func _test_links():
	assert(_tile_maker != null)
	assert(_entity_manager != null)
	assert(_tile_manager != null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test_links()
	_connect_signals()
	_build_dungeon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
