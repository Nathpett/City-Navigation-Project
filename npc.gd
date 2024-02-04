extends CharacterBody2D

var movement_speed: float = 100.0
var movement_target_position: Vector2
var city: City

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	city = get_parent()
	
	$StateMachine.change_state("wander")


func seek(new_goal_position: Vector2):
	movement_target_position = new_goal_position
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _physics_process(delta):
	if navigation_agent.is_navigation_finished() and !navigation_agent.is_target_reached():
		actor_setup()

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
