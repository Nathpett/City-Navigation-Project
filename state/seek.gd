class_name Seek
extends State


var target


func enter() -> void:
	super.enter()
	cycle_freq = 1
	target = parameters["target"]
	target.modulate = Color.BLACK
	state_owner.navigation_agent.connect("navigation_finished", Callable(self, "_exit_condition_met"))


func _process(delta):
	if !cycle_timer.is_stopped():
		return
	
	cycle_timer.start(cycle_freq)
	state_owner.set_target(target.global_position)


func _exit_condition_met() -> void:
	target.queue_free()
	emit_signal("state_concluded")

