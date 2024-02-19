extends State


func enter() -> void:
	var see_hit_box: Area2D = state_owner.get_node("SeeHitBox")
	see_hit_box.collision_layer = 0
	
	state_owner.connect("drop", Callable(self, "_on_drop"))
	state_owner.visible = false


func exit() -> void:
	var see_hit_box: Area2D = state_owner.get_node("SeeHitBox")
	see_hit_box.collision_layer = 2
	state_owner.visible = true
