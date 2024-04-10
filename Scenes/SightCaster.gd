class_name SightCaster
extends Node2D

@export var degrees_per_raycast := 15

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
	var active_ray_dict = {}
	var ray_length = TileInfo.CURRENT_DIMENSIONS.x
	var ray: RayCast2D = $RayCast2D
	
	var cycles := 2
	
	var spotted_tiles = {}
	
	for i in range(0, 360, degrees_per_raycast):
		active_ray_dict[i] = true
		
	print(str(active_ray_dict.keys()))
		
	for i in range(1, cycles + 1):		
		ray.target_position.y = ray_length * i
		for ray_degree in active_ray_dict:
			ray.rotation = deg_to_rad(ray_degree)
			ray.force_raycast_update()
			var collision = ray.get_collider()
			if collision is DetectionSquare:
				var tile: Tile = collision.tile
				print("Ray collision with " + tile.tile_name)
				if active_ray_dict[ray_degree] == true:
					spotted_tiles[tile] = true
				ray.add_exception(collision)
				if not tile.transparent:
					print(tile.tile_name + " is not transparent")
					active_ray_dict[ray_degree] = false
						
				print("Scan of " + str(ray_degree) + " completed")
	
	for tile in spotted_tiles:
		assert(tile is Tile, "tile is not Tile but " + str(type_string(typeof(tile))))
		_tiles_in_sight.append(tile)
				
	ray.clear_exceptions()
	
""" Below code only functional with old base type of Area2D
func _add_tiles_in_range_OLD():
	for object in get_overlapping_bodies():
		if object is DetectionSquare:
			var parent_tile = object.tile
			_tiles_in_sight.append(parent_tile)
"""
