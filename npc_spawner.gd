extends Node2D

var npc_packed_scene: PackedScene

func _ready() -> void:
	npc_packed_scene = load("res://npc.tscn")
	
	call_deferred("_spawn")
	while(true):
		$Timer.start()
		await $Timer.timeout
		_spawn()


func _spawn() -> void:
	var new_npc = npc_packed_scene.instantiate()
	
	get_parent().add_child(new_npc)
	new_npc.position = position
