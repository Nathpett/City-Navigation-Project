class_name Seek
extends NpcBaseState


var target


func enter() -> void:
	super.enter()
	cycle_freq = 0.5
	target = parameters["target"]
	state_owner.navigation_agent.connect("navigation_finished", Callable(self, "_exit_condition_met"))


func pause() -> void:
	super.pause()
	state_owner.set_movement_target(null)


func unpause() -> void:
	state_owner.set_movement_target(target.global_position)
	super.unpause()


func _process(_delta):
	if !cycle_timer.is_stopped():
		return
	
	cycle_timer.start(cycle_freq)
	state_owner.set_movement_target(target.global_position)


func _exit_condition_met() -> void:
	var nav_agent: NavigationAgent2D = state_owner.navigation_agent
	state_owner.state_successful = nav_agent.is_navigation_finished()
	emit_signal("state_concluded")

