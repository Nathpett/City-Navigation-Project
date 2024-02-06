class_name WanderState
extends State

var look_timer: Timer
var look_freq: int = 3

func enter() -> void:
	look_timer = Timer.new()
	add_child(look_timer)
	look_timer.start(look_freq)
	look_timer.one_shot = true
	
	while(true):
		var target_building = state_owner.city.random_building()
		state_owner.seek(target_building.get_node("Enterance").global_position)
		await state_owner.navigation_agent.navigation_finished
		var target_goal = target_building.random_goal()
		state_owner.seek(target_goal.global_position)
		await state_owner.navigation_agent.navigation_finished
		await get_tree().create_timer(3).timeout


func _physics_process(delta):
	if !look_timer.is_stopped():
		return
	
	look_timer.start(look_freq)
	state_owner.look()
