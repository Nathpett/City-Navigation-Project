class_name WanderState
extends State

var target_building
var stops: Array

func enter() -> void:
	super.enter()
	stops = []

# TODO Why does it wait for a moment at stops? 
func _physics_process(delta):
	if stops.size() == 0:
		populate_stops()
	if state_owner.navigation_agent.is_navigation_finished():
		state_owner.set_target(stops.pop_back())

	
	if !cycle_timer.is_stopped():
		return
	
	cycle_timer.start(cycle_freq)
	
	var things_seen: Array = state_owner.look()
	if things_seen.is_empty():
		return
	things_seen.shuffle()
	for thing in things_seen:
		if thing: # if thing meets search criteria TODO
			push_state.call("seek", {"target": thing})
			return


func populate_stops() -> void:
	target_building = state_owner.city.random_building()
	stops.append(target_building.get_node("Enterance").global_position)
	var target_goal = target_building.random_goal()
	stops.append(target_goal.global_position)
