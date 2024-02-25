class_name StateMachine
extends Node

var state
var state_stack: Array


func push_state(state_name, parameters = null, overwrite = false):
	if state != null and !state.is_queued_for_deletion():
		if overwrite:
			state.exit()
		else:
			state.pause()
			state_stack.append(state)
	state = Node.new()
	var _script = _get_state_script(state_name)
	state.set_script(_script)
	state.state_owner = get_parent()
	state.connect("state_concluded", Callable(self, "_on_state_concluded"))
	add_child(state)
	if parameters == null:
		parameters = {}
	else:
		state.parameters = parameters
	state.enter()
	
	return state


func _on_state_concluded() -> void:
	state.exit()
	if len(state_stack) > 0:
		state = state_stack.pop_back()
		state.unpause()


func _get_state_script(state_name: String):
	var state_dir = DirAccess.open("res://state")
	
	for dir_name in state_dir.get_directories():
		var dir = DirAccess.open("res://state/%s" % dir_name)
		var script_path = "res://state/%s/%s.gd" % [dir_name, state_name]
		if dir.file_exists(script_path):
			return load(script_path)
	return ""
