class_name Seek
extends State


var target


func enter() -> void:
	super.enter()
	cycle_freq = 0.5
	target = parameters["target"]
	state_owner.navigation_agent.connect("navigation_finished", Callable(self, "_exit_condition_met"))


func _process(delta):
	if !cycle_timer.is_stopped():
		return
	
	cycle_timer.start(cycle_freq)
	state_owner.set_movement_target(target.global_position)


func _exit_condition_met() -> void:
	state_owner.pick_up(target)
	emit_signal("state_concluded")

