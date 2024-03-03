class_name Character
extends Thing

var movement_speed: float = 100.0
var holding = null
var city: City


func _ready():
	city = get_parent()


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
