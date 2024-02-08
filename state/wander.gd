class_name WanderState
extends State

var look_timer: Timer
var look_freq: int = 1
var target_building

func enter() -> void:
	look_timer = Timer.new()
	add_child(look_timer)
	look_timer.start(look_freq)
	look_timer.one_shot = true
	
	cycle()


func cycle() -> void: # TODO REWRITE SO ALL LOGIC IS IN PROCESS
	target_building = state_owner.city.random_building()
	state_owner.set_target(target_building.get_node("Enterance").global_position)
	await state_owner.navigation_agent.navigation_finished
	var target_goal = target_building.random_goal()
	await state_owner.navigation_agent.navigation_finished
	await get_tree().create_timer(3).timeout
	emit_signal("cycle_finished")


func _physics_process(delta):
	if !look_timer.is_stopped():
		return
	
	look_timer.start(look_freq)
	var things_seen: Array = state_owner.look()
	if things_seen.is_empty():
		return
	things_seen.shuffle()
	for thing in things_seen:
		if thing: # if thing meets search criteria TODO
			push_state.call("seek", {"target": thing})
			return
