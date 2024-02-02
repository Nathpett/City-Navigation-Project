class_name City
extends Node2D


func random_goal() -> Node2D:
	return $Goals.get_children().pick_random()
