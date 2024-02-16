extends State


func enter() -> void:
	var see_hit_box: Area2D = state_owner.get_node("SeeHitBox")
	see_hit_box.collision_layer = 0
	
	state_owner.connect("drop", Callable(self, "_on_drop"))


func exit() -> void:
	var see_hit_box: Area2D = state_owner.get_node("SeeHitBox")
	see_hit_box.collision_layer = 2


func _on_drop() -> void:
	get_parent().push_state("out")
