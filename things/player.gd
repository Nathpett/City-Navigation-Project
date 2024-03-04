extends Character


func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction += Vector2.UP
	if Input.is_action_pressed("down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	
	velocity = direction * movement_speed
	
	move_and_slide()
