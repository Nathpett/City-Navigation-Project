extends Node

signal prime_physics
signal round_begin
signal turn_body
signal round_end
signal round_conclude
signal cleanup_round

var character_registry: Array = []
var is_player_turn: bool = false


func _ready():
	call_deferred("main_loop")


func main_loop() -> void:
	while true:
		execute_round()
		await round_conclude



func register_character(character: Character) -> void:
	character_registry.append(character)


func execute_round():
	emit_signal("prime_physics")
	await get_tree().physics_frame
	emit_signal("round_begin")
	
	var sorted_characters = _get_sorted_characters()
	for character in sorted_characters:
		if character.is_player():
			is_player_turn = true
			await character.round_done
			is_player_turn = false
		else:
			character.process_turn_body()
	
	emit_signal("round_end")
	emit_signal("cleanup_round")
	call_deferred("emit_signal", "round_conclude")


func _get_sorted_characters() -> Array:
	var sorted_characters = character_registry.duplicate()
	sorted_characters.sort_custom(Callable(self, "_execute_priority"))
	
	return sorted_characters


func _execute_priority(a, b) -> bool:
	return a.execute_priority < b.execute_priority
