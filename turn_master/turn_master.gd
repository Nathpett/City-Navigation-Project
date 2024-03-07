extends Node

signal prime_physics
signal turn_begin
signal turn_body
signal turn_end
signal cleanup_turn


func execute_turn():
	emit_signal("prime_physics")
	await get_tree().physics_frame
	emit_signal("turn_begin")
	emit_signal("turn_body")
	emit_signal("turn_end")
	emit_signal("cleanup_turn")
