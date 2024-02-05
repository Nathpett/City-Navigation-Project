class_name StateMachine
extends Node

var state
var state_stack: Array


func push_state(state_name) -> void:
	if state != null:
		state.pause()
		state_stack.append(state)
	state = Node.new()
	state.set_script(load("res://state/%s.gd" % [state_name]))
	state.state_owner = get_parent()
	state.push_state = Callable(self, "push_state")
	state.connect("exit_state", Callable(self, "_state_exited"))
	add_child(state)
	state.enter()


func _state_exited() -> void:
	state = state_stack.pop_back()
	state.unpause()
