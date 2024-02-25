extends NpcBaseState


func enter() -> void:
	await get_tree().create_timer(2).timeout
	emit_signal("state_concluded")


func _physics_process(_delta):
	pass
