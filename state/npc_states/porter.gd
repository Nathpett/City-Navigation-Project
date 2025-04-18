extends State

var sub_state

func enter() -> void:
	call_deferred("state_logic")


func state_logic() -> void:
	while true:
		sub_state = state_machine.push_state("wander_and_find", {"exit_criteria": "thing"})
		await sub_state.state_concluded
		
		sub_state = state_machine.push_state("seek", {"target": state_owner.get_meta("target")})
		await sub_state.state_concluded 
		
		var ported_item
		if state_owner.state_successful:
			ported_item = state_owner.get_meta("target")
			state_owner.pick_up(ported_item)
		else:
			continue
		
		sub_state = state_machine.push_state("wander_and_find", {"exit_criteria": "box"})
		await sub_state.state_concluded
		
		var box = state_owner.get_meta("target")
		sub_state = state_machine.push_state("seek", {"target": box})
		await sub_state.state_concluded
		
		box.store(ported_item)
		
		
