class_name Goal
extends Node2D

func random_goal() -> Node2D:
	return $Goals.get_children().pick_random()
	
