class_name WanderState
extends State

var target_building
var stops: Array

func enter() -> void:
	super.enter()
	state_owner.get_node("NavigationAgent2D").connect("navigation_finished", Callable(self, "_on_state_owner_navigation_finished"))
	stops = []


func _physics_process(_delta):
	if !cycle_timer.is_stopped():
		return
	
	cycle_timer.start(cycle_freq)
	
	if state_owner.holding != null:
		return
	
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
	stops.append(target_building.get_node("Enterance"))
	var target_goal = target_building.random_goal()
	stops.append(target_goal)


func _on_state_owner_navigation_finished() -> void:
	if stops.size() == 0:
		populate_stops()
		if state_owner.holding:
			state_owner.drop()
	state_owner.set_movement_target(stops.pop_front().global_position)
