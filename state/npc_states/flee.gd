extends NpcBaseState

var average_scary_thing_position:= Vector2.ZERO
var flee_turns = 20


func _ready():
	super._ready()
	state_owner.connect("saw_thing", Callable(self, "_prime_reassess"))


func _physics_process(_delta):
	if has_physics_this_round:
		return
	
	flee_turns -= 1
	
	super._physics_process(_delta)
	
	var scary_thing_ct = 0
	for thing in things_seen:
		if thing.flee_from_debug:
			if scary_thing_ct == 0:
				average_scary_thing_position = Vector2.ZERO
			scary_thing_ct += 1
			average_scary_thing_position += thing.global_position
	
	if scary_thing_ct > 0:
		average_scary_thing_position /= scary_thing_ct
	
	var dirs := []
	for i in range(8):
		dirs.append(float(i)/8 * TAU)
	
	var approx_scary_thing_dir: Vector2 = state_owner.global_position.direction_to(average_scary_thing_position)
	var prox_angle = approx_scary_thing_dir.angle()
	var quart_pi = PI / 4.0
	prox_angle = round(prox_angle / quart_pi) * quart_pi
	dirs.erase(prox_angle)
	
	var possible_navs := []
	var space_state = state_owner.get_world_2d().direct_space_state
	for dir in dirs:
		var vecdir := Vector2.RIGHT.rotated(dir)
		var look_edge: Vector2 = state_owner.global_position + vecdir * state_owner.sight_range * 2.0
		var query = PhysicsRayQueryParameters2D.create(state_owner.global_position, look_edge, 1)
		var results = space_state.intersect_ray(query)
		possible_navs.append(results.get("position", look_edge))
	
	# seek the nav that is the furthest from the average position of all things to flee from
	var champ_nav = Vector2.ZERO
	var champ_dist := 0.0
	for nav in possible_navs:
		var dist = nav.distance_squared_to(average_scary_thing_position)
		if dist > champ_dist:
			champ_dist = dist
			champ_nav = nav
	state_owner.set_movement_target(champ_nav)


func _on_cleanup_turn() -> void:
	if flee_turns == 0:
		emit_signal("state_concluded")
