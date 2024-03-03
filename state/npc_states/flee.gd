extends NpcBaseState

var exit_timer: Timer
var reassess_navigation: bool = true
var average_scary_thing_position:= Vector2.ZERO
var reassess_timer
var flee_time = 4

func _ready():
	exit_timer = Timer.new()
	add_child(exit_timer)
	
	reassess_timer = Timer.new()
	add_child(reassess_timer)
	
	reassess_timer.start(0.1)
	
	exit_timer.connect("timeout", Callable(self, "emit_signal").bind("state_concluded"))
	reassess_timer.connect("timeout", Callable(self, "_prime_reassess"))
	state_owner.connect("saw_thing", Callable(self, "_prime_reassess"))


#func enter() -> void:
	#await get_tree().create_timer(2).timeout
	#emit_signal("state_concluded")


func _physics_process(_delta):
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
		exit_timer.stop()
		exit_timer.start(flee_time)
	
	if !reassess_navigation:
		return
	
	reassess_navigation = false
	
	var dirs := []
	for i in range(8):
		dirs.append(float(i)/8 * TAU)
	
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


func _prime_reassess() -> void:
	reassess_navigation = true
	reassess_timer.stop()
	reassess_timer.start(0.1)
