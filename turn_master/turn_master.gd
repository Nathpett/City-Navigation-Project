extends Node

signal turn_begin
signal turn_body
signal turn_end


func execute_turn():
	emit_signal("turn_begin")
	emit_signal("turn_body")
	emit_signal("turn_end")
