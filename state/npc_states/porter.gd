extends State


func enter() -> void:
	call_deferred("state_logic")


func state_logic() -> void:
	while true:
		state_machine.push_state("wander", {"exit_criteria": "thing"})
		await state_machine.state_concluded
		
		state_machine.push_state("seek", {"target": state_owner.get_meta("target")})
		await state_machine.state_concluded
		
		var ported_item
		if state_owner.state_successful:
			ported_item = state_owner.get_meta("target")
			state_owner.pick_up(ported_item)
		else:
			continue
		
		state_machine.push_state("wander", {"exit_criteria": "box"})
		await state_machine.state_concluded
		
		var box = state_owner.get_meta("target")
		state_machine.push_state("seek", {"target": box})
		await state_machine.state_concluded
		
		box.store(ported_item)
		
		
