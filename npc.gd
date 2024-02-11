extends CharacterBody2D


var movement_speed: float = 100.0
var movement_target_position: Vector2
var city: City
var in_sight_range: Array

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	city = get_parent()
	in_sight_range = []
	
	$StateMachine.push_state("wander")


func look() -> Array: # ONLY CALL IN PHYSICS PROCESS
	var space_state = get_world_2d().direct_space_state
	var true_seen = []
	for thing in in_sight_range:
		var query = PhysicsRayQueryParameters2D.create(global_position, thing.global_position, 1)
		if !space_state.intersect_ray(query):
			true_seen.append(thing)
	
	return true_seen


func pick_up() -> void:
	pass # TODO NEXT


func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)


func set_movement_target(movement_target: Vector2):
	movement_target_position = movement_target
	navigation_agent.target_position = movement_target_position


func _physics_process(_delta):
	if navigation_agent.is_navigation_finished() and !navigation_agent.is_target_reached():
		set_movement_target(movement_target_position)

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var direction = current_agent_position.direction_to(next_path_position)
	velocity = direction * movement_speed
	
	move_and_slide()


func _get_closest_cardinal_vecotr(vec2: Vector2):
	var max_dot_product = -1.0
	var closest_direction = Vector2.ZERO

	# Calculate dot product for each cardinal direction
	for direction in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var dot_product = vec2.dot(direction)
		if dot_product > max_dot_product:
			max_dot_product = dot_product
			closest_direction = direction

	return closest_direction


func _on_sight_area_area_entered(area):
	var thing = area.get_parent()
	if thing == self:
		return
	in_sight_range.append(thing)


func _on_sight_area_area_exited(area):
	in_sight_range.erase(area.get_parent())
