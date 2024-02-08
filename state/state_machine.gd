class_name StateMachine
extends Node

var state
var state_stack: Array


func push_state(state_name, parameters = null) -> void:
	if state != null:
		state.pause()
		remove_child(state)
		state_stack.append(state)
	state = Node.new()
	state.set_script(load("res://state/%s.gd" % [state_name]))
	state.state_owner = get_parent()
	state.push_state = Callable(self, "push_state")
	state.connect("exit_state", Callable(self, "_state_exited"))
	add_child(state)
	state.parameters = parameters
	state.enter()


func pop_state() -> void: # TODO Could be race condition if state pushed on same frame where it would have left?
	state.exit()
	state.queue_free()
	if len(state_stack) == 0:
		return
	var prev_state = state_stack.pop_back()
	add_child(prev_state)
	prev_state.unpause()


func _state_exited() -> void:
	state = state_stack.pop_back()
	state.unpause()
