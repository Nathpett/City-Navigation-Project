class_name State
extends Node

signal exit_state
signal state_concluded
signal cycle_finished

var state_owner
var push_state 
var parameters


func _ready():
	self.connect("cycle_finished", Callable(self, "cycle"))


func cycle() -> void:
	await get_tree().create_timer(1000).timeout
	emit_signal("cycle_finished")


func enter() -> void:
	pass


func exit() -> void:
	emit_signal("exit_state")
	queue_free()


func pause() -> void:
	pass
	#self.process_mode = Node.PROCESS_MODE_DISABLED


func unpause() -> void:
	pass
	#self.process_mode = Node.PROCESS_MODE_PAUSABLE


