class_name State
extends Node

var state_owner
var change_state 


func enter() -> void:
	pass


func exit() -> void:
	pass


func setup(new_change_state, new_state_owner) -> void:
	self.change_state = new_change_state
	self.state_owner = new_state_owner
