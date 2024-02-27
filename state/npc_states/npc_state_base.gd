class_name NpcBaseState
extends State

var things_seen: Array = []

func _physics_process(_delta):
	things_seen = state_owner.look()
	
	if get_script().get_path() != "res://state/npc_states/flee.gd":
		for thing in things_seen:
			if thing.flee_from_debug:
				state_machine.push_state("flee")
				return
