class_name WanderAndSeekFind
extends NpcBaseState

# State makes NPC wander city until it finds a specific object

var target_building
var stops: Array
var exit_criteria: String


func enter() -> void:
	super.enter()
	state_owner.get_node("NavigationAgent2D").connect("navigation_finished", Callable(self, "_on_state_owner_navigation_finished"))
	stops = []
	
	exit_criteria = parameters.get("exit_criteria", "thing")
	_on_state_owner_navigation_finished()


func _physics_process(_delta):
	if has_physics_this_turn:
		return
	super._physics_process(_delta)
	if things_seen.is_empty():
		return
	things_seen.shuffle()
	for thing in things_seen:
		if thing.get_script().get_path().get_file().get_basename() == exit_criteria:
			state_owner.set_meta("target", thing)
			state_owner.state_successful = true
			emit_signal("state_concluded")
			return


func populate_stops() -> void:
	target_building = state_owner.city.random_building()
	stops.append(target_building.get_node("Enterance"))
	var target_goal = target_building.random_goal()
	stops.append(target_goal)


func _on_state_owner_navigation_finished() -> void:
	if stops.size() == 0:
		populate_stops()
	state_owner.set_movement_target(stops.pop_front().global_position)
