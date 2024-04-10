class_name SightCircle
extends Area2D

var _tiles_in_sight = []
var tiles_in_sight: int:
	get:
		return len(_tiles_in_sight)

var tiles_illuminated := false

const highlight_color := Color.YELLOW

func _clear_existing_tiles():
	for tile in _tiles_in_sight:
		tile.color = tile.base_color * 0.5
		
	_tiles_in_sight.clear()

func _highlight_tiles_in_range():
	for tile in _tiles_in_sight:
		tile.color = highlight_color
		tile.visible = true

func _wait_for_physics_update():
	# Why does this need to be done? Because Godot is goofy about its physics frames...
	# This is a workaround to prevent constant updating of vision as the alternative.
	# The visual update frame seems to be two frames behind, thus the magic number.
	
	var wait_counter = 0
	while wait_counter < 2:
		await get_tree().physics_frame
		wait_counter += 1

func update_visible_tiles():
	await _wait_for_physics_update()
	_clear_existing_tiles()
	_add_tiles_in_range()
	_highlight_tiles_in_range()

func _add_tiles_in_range():
	for object in get_overlapping_bodies():
		if object is DetectionSquare:
			var parent_tile = object.tile
			_tiles_in_sight.append(parent_tile)
