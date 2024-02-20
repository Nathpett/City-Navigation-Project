extends State


func enter() -> void:
	call_deferred("state_logic")


func state_logic() -> void:
	state_machine.push_state("wander", {"exit_criteria": "thing"})
	#state_machine.push_state("wander", {"exit_criteria": "thing"})
	await state_machine.state_concluded
	state_machine.push_state("seek", {"target": state_owner.get_meta("target")})
