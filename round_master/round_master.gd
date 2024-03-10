extends Node

signal prime_physics
signal turn_begin
signal turn_body
signal turn_end
signal cleanup_turn

var character_registry: Array = []


func register_character(character: Character) -> void:
	character_registry.append(character)


func execute_round():
	emit_signal("prime_physics")
	await get_tree().physics_frame
	emit_signal("turn_begin")
	
	var sorted_characters = _get_sorted_characters()
	for character in sorted_characters:
		character.process_turn_body()
	
	emit_signal("turn_end")
	emit_signal("cleanup_turn")


func _get_sorted_characters() -> Array:
	var sorted_characters = character_registry.duplicate()
	sorted_characters.sort_custom(Callable(self, "_execute_priority"))
	
	return sorted_characters


func _execute_priority(a, b) -> bool:
	return a.execute_priority < b.execute_priority
