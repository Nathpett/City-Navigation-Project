extends Character

var turn_exhausted = true


func _input(event):
	if turn_exhausted:
		return
	
	var just_pressed = event.is_pressed() and !event.is_echo()
	var just_released = event.is_released() and !event.is_echo()
	
	var direction: Vector2
	var valid_press: bool
	if just_pressed:
		if event.is_action_pressed("up"):
			direction += Vector2.UP
			valid_press = true
		if event.is_action_pressed("down"):
			direction += Vector2.DOWN
			valid_press = true
		if event.is_action_pressed("right"):
			direction += Vector2.RIGHT
			valid_press = true
		if event.is_action_pressed("left"):
			direction += Vector2.LEFT
			valid_press = true
		
		if valid_press:
			TurnMaster.execute_turn()
	
	position += direction * city.get_tile_size()
