class_name StateMachine
extends Node

var state


func change_state(state_name) -> void:
	if state != null:
		state.exit()
		state.set_physics_process(false)
		state.set_process(false)
		state.queue_free()
	state = Node.new()
	state.set_script(load("res://state/%s.gd" % [state_name]))
	state.name = state_name
	state.setup(Callable(self, "change_state"), get_parent())
	add_child(state)
	state.enter()
