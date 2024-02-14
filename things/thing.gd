extends Node2D


func evoke_pickup():
	$StateMachine.push_state("carry")
