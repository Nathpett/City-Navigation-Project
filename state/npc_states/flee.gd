extends NpcBaseState


func enter() -> void:
	await get_tree().create_timer(2).timeout
	emit_signal("state_concluded")


func _physics_process(_delta):
	super._physics_process(_delta)
	var things_to_flee_from_normalized := Vector2.ZERO
	for thing in things_seen:
		if thing.flee_from_debug:
			var vec_to: Vector2 = thing.position - state_owner.position
			vec_to = -vec_to.normalized()
			things_to_flee_from_normalized += vec_to
	state_owner.manual_nav_vector = things_to_flee_from_normalized.normalized() # TODO NEXGT ONLY REPLACE IF ATLEAST ONE THING TO FLEE FROM SEEN!
		
