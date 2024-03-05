class_name City
extends Node2D


func random_building() -> Node2D:
	return $Buildings.get_children().pick_random()


func get_tile_size() -> Vector2:
	return $TileMap.tile_set.tile_size
