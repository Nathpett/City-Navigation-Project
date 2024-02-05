class_name State
extends Node

signal exit_state

var state_owner
var push_state 


func enter() -> void:
	pass


func exit() -> void:
	emit_signal("exit_state")
	queue_free()


func pause() -> void:
	pass


func unpause() -> void:
	pass
