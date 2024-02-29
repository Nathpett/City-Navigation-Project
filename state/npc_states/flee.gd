extends NpcBaseState

var exit_timer: Timer
var reassess_navigation: bool = true

func _ready():
	exit_timer = Timer.new()
	add_child(exit_timer)
	exit_timer.connect("timeout", Callable(self, "emit_signal").bind("state_concluded"))


func enter() -> void:
	await get_tree().create_timer(2).timeout
	emit_signal("state_concluded")


func _physics_process(_delta):
	super._physics_process(_delta)
	
	# TODO REWRITE THIS BLOCK TO TRIGGER REASSESSMENTS AND SET AVERAGE
	
	
	var scary_things_normalized := Vector2.ZERO
	var any_scary_thing:= false
	var average_scary_thing_position: Vector2
	for thing in things_seen:
		if thing.flee_from_debug:
			any_scary_thing = true
			var vec_to: Vector2 = thing.position - state_owner.position
			vec_to = -vec_to.normalized()
			scary_things_normalized += vec_to
	if scary_things_normalized != Vector2.ZERO:
		state_owner.manual_nav_vector = scary_things_normalized.normalized()
	if any_scary_thing:
		exit_timer.stop()
		exit_timer.start(2)
	
	if !reassess_navigation:
		return
	
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
		var dist = nav.distance_squared_to()
		if dist > champ_dist:
			champ_dist = dist
			champ_nav = nav
	
	state_owner.set_movement_target(champ_nav)



	#var things_to_flee_from_normalized := Vector2.ZERO
	#var any_things_to_flee_from:= false
	#for thing in things_seen:
		#if thing.flee_from_debug:
			#any_things_to_flee_from = true
			#var vec_to: Vector2 = thing.position - state_owner.position
			#vec_to = -vec_to.normalized()
			#things_to_flee_from_normalized += vec_to
	#if things_to_flee_from_normalized != Vector2.ZERO:
		#state_owner.manual_nav_vector = things_to_flee_from_normalized.normalized()
	#if any_things_to_flee_from:
		#exit_timer.stop()
		#exit_timer.start(2)
