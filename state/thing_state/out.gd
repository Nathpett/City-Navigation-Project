extends State


func enter() -> void:
	var see_hit_box: Area2D = state_owner.get_node("SeeHitBox")
	see_hit_box.set_collision_layer_value(2, true)
