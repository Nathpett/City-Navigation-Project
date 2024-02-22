extends Thing

@export var storage_capacity = 3

var store_stack: Array = []


func store(thing: Thing) -> void:
	store_stack.append(thing)
	thing.evoke_stored()


func can_store() -> bool:
	return storage_capacity != len(store_stack)
