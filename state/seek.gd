class_name Seek
extends State

var target

func enter() -> void:
	target = parameters["target"]
	
	while(true):
		state_owner.set_target(target.global_position)
		await state_owner.navigation_agent.navigation_finished
		target.queue_free()
