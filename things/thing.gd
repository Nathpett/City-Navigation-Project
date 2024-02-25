class_name Thing
extends CharacterBody2D

signal dropped

@export var flee_from_debug = false

func evoke_pickup():
	$StateMachine.push_state("held",  null, true)


func evoke_drop():
	emit_signal("dropped")


func evoke_stored():
	$StateMachine.push_state("stored")
