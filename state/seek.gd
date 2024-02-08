class_name Seek
extends State

var cycle_timer: Timer # TODO just make this a part of the state class
var cycle_freq: int = 1
var target

func enter() -> void:
	target = parameters["target"]
	cycle_timer = Timer.new()
	cycle_timer.one_shot = true
	
	state_owner.navigation_agent.connect("navigation_finished", Callable(self, "_exit_condition_met"))


func _process(delta):
	if !cycle_timer.is_stopped():
		return
	
	cycle_timer.start(cycle_freq)
	state_owner.set_target(target.global_position)


func _exit_condition_met() -> void:
	target.queue_free()
	emit_signal("state_concluded")

