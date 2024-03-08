class_name City
extends Node2D


func random_building() -> Node2D:
	return $Buildings.get_children().pick_random()


func get_tile_size() -> Vector2:
	return $TileMap.tile_set.tile_size


func get_map_local(g_position: Vector2i):
	var l_position = to_local(g_position)
	return $TileMap.local_to_map(l_position)


func map_to_global(map_pos: Vector2i):
	var tile_size = $TileMap.tile_set.tile_size
	return Vector2(to_global(tile_size * map_pos)) + Vector2((tile_size / 2))


func is_collide(tile: Vector2i) -> bool:
	var tile_data = $TileMap.get_cell_tile_data(0, tile)
	if tile_data.get_collision_polygons_count(0) > 0:
		return true
	return false
