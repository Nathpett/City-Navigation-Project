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
	var _script = _get_state_script(state_name)
	state.set_script(_script)
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


func _get_state_script(state_name: String):
	var state_dir = DirAccess.open("res://state")
	
	for dir_name in state_dir.get_directories():
		var dir = DirAccess.open("res://state/%s" % dir_name)
		var script_path = "res://state/%s/%s.gd" % [dir_name, state_name]
		if dir.file_exists(script_path):
			return load(script_path)
	return ""
