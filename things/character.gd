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


func _get_cell() -> Vector2i:
	return cellify(global_position)


func cellify(pos: Vector2):
	var tile_size: Vector2 = city.get_tile_size()
	var vec = pos / tile_size
	return Vector2i(vec)


func position_from_cel(vec: Vector2i) -> Vector2:
	var tile_size: Vector2 = city.get_tile_size()
	
	return Vector2(vec * tile_size.x)
