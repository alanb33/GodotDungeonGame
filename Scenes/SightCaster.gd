class_name SightCaster
extends Node2D

var _tiles_in_sight: Dictionary = {}
var tiles_in_sight: int:
	get:
		return len(_tiles_in_sight.keys())

func _clear_existing_tiles():
	for tile in _tiles_in_sight:
		tile.unhighlight()
		
	_tiles_in_sight.clear()

func _highlight_tile(tile: Tile):
	tile.highlight()

func _highlight_tiles_in_range():
	for tile in _tiles_in_sight:
		tile.highlight()

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
	
	var search_degree = 15
	var search_radius = 3
	
	_add_tiles_in_range(search_degree, search_radius)
	_highlight_tiles_in_range()
	
func _get_tiles_with_raycast_from_degree(degree: int, search_radius: int):
	
	var tile_size := TileInfo.CURRENT_DIMENSIONS.y
	
	var ray_length = tile_size * search_radius 
	var ray_min = 0
	
	var space_state = get_world_2d().direct_space_state
	
	# The destination formula: x = cos(deg), y = sin(deg)
	var destination_x = cos(deg_to_rad(degree)) * ray_length
	var destination_y = sin(deg_to_rad(degree)) * ray_length
	
	var destination = Vector2(global_position.x + destination_x, global_position.y + destination_y)
	
	var tile_hits = {}
	
	var query = PhysicsRayQueryParameters2D.create(global_position, destination)
	query.hit_from_inside = true
	while ray_min <= ray_length:
		var result = space_state.intersect_ray(query)
		if result:
			var distance_diff = global_position.distance_to(result.position)
			if distance_diff > ray_min:
				break
			else:
				query.exclude += [result.rid]
				if result.collider is DetectionSquare:
					var tile = result.collider.tile
					tile_hits[tile] = true
					if not tile.transparent:
						break
				ray_min += TileInfo.CURRENT_DIMENSIONS.y
		else:
			break
	
	return tile_hits
	
func _add_tiles_in_range(degrees_per_scan: int, search_radius: int):
	
	var steps = 360 / degrees_per_scan
	assert(steps % 1 == 0, "Degrees per scan gives uneven number of steps (" + str(steps) + ")")
	
	for i in range(0, steps):
		var scan_degree = i * degrees_per_scan
		var tiles_from_scan = _get_tiles_with_raycast_from_degree(scan_degree, search_radius)
		_tiles_in_sight.merge(tiles_from_scan, true)

