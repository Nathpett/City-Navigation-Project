class_name WanderState
extends State


func enter() -> void:
	while(true):
		var target_building = state_owner.city.random_building()
		state_owner.seek(target_building.get_node("Enterance").global_position)
		await state_owner.navigation_agent.navigation_finished
		var target_goal = target_building.random_goal()
		state_owner.seek(target_goal.global_position)
		await state_owner.navigation_agent.navigation_finished
		await get_tree().create_timer(3).timeout
