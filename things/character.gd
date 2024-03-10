class_name Character
extends Thing

var movement_speed: float = 100.0
var holding = null
var city: City

@export var execute_priority: int = 0


func _ready():
	super._ready()
	
	city = get_parent()
	
	RoundMaster.register_character(self)


func process_turn_body() -> void:
	pass


func move_character(direction: Vector2i) -> void:
	var possible_tile = city.get_map_local(global_position) + direction
	if city.is_collide(possible_tile):
		return
	position = city.map_to_global(possible_tile) # TODO use tween?


func pick_up(thing: Thing) -> void:
	thing.evoke_pickup()
	thing.get_parent().remove_child(thing)
	add_child(thing)
	holding = thing
	
	# position thing
	thing.position = Vector2(0, -5)


func drop() -> void:
	holding.evoke_drop()
	holding.position = global_position
	remove_child(holding)
	get_parent().add_child(holding)
	
	holding = null
