class_name City
extends Node2D


func random_building() -> Node2D:
	return $Buildings.get_children().pick_random()
