class_name NpcBaseState
extends State

var things_seen: Array = []

func _physics_process(_delta):
	things_seen = state_owner.look()
	
	for thing in things_seen:
		if thing.flee_from_debug:
			state_machine.push_state("flee")
			thing.queue_free()
			return
	# Do things like push for the Flee state #TODO
