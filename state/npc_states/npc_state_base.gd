class_name NpcBaseState
extends State

var things_seen: Array = []

var seen_flee: bool = false
var has_physics_this_round: bool = false


func _ready():
	super._ready()
	RoundMaster.connect("prime_physics", Callable(self, "set").bind("has_physics_this_round", false))
	RoundMaster.connect("cleanup_turn", Callable(self, "_on_cleanup_turn"))


func _physics_process(_delta):
	if has_physics_this_round:
		return
	call_deferred("set", "has_physics_this_round", true)
	
	things_seen = state_owner.look()
	
	if get_script().get_path() != "res://state/npc_states/flee.gd":
		seen_flee = false
		for thing in things_seen:
			if thing.flee_from_debug:
				seen_flee = true
				break
		
		if seen_flee:
			state_machine.push_state("flee")


func _on_cleanup_turn() -> void:
	pass
