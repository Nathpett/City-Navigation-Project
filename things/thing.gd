class_name Thing
extends Node2D

signal drop

func evoke_pickup():
	$StateMachine.push_state("held",  null, true)


func evoke_drop():
	emit_signal("drop")


func evoke_stored():
	$StateMachine.push_state("stored")
