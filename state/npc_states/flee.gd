extends NpcBaseState

var exit_timer: Timer


func _ready():
	exit_timer = Timer.new()
	add_child(exit_timer)
	exit_timer.connect("timeout", Callable(self, "emit_signal").bind("state_concluded"))


func enter() -> void:
	await get_tree().create_timer(2).timeout
	emit_signal("state_concluded")


func _physics_process(_delta):
	super._physics_process(_delta)
	var things_to_flee_from_normalized := Vector2.ZERO
	var any_things_to_flee_from:= false
	for thing in things_seen:
		if thing.flee_from_debug:
			any_things_to_flee_from = true
			var vec_to: Vector2 = thing.position - state_owner.position
			vec_to = -vec_to.normalized()
			things_to_flee_from_normalized += vec_to
	if things_to_flee_from_normalized != Vector2.ZERO:
		state_owner.manual_nav_vector = things_to_flee_from_normalized.normalized()
	if any_things_to_flee_from:
		exit_timer.stop()
		exit_timer.start(2)
