class_name StateMachine
extends Node

var state
var state_stack: Array


func push_state(state_name, parameters = null, overwrite = false) -> void:
	if state != null:
		if overwrite:
			state.exit()
		else:
			state.pause()
			state_stack.append(state)
	state = Node.new()
	state.set_script(load("res://state/%s.gd" % [state_name]))
	state.state_owner = get_parent()
	state.push_state = Callable(self, "push_state")
	state.connect("state_concluded", Callable(self, "_on_state_concluded"))
	add_child(state)
	state.parameters = parameters
	state.enter()


func _on_state_concluded() -> void:
	state.exit()
	if len(state_stack) == 0:
		return
	state = state_stack.pop_back()
	state.unpause()
