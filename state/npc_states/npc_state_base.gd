class_name NpcBaseState
extends State

var things_seen: Array = []

var flee_streak: int = 0 # running streak of frames that state_owner has seen a think worth fleeing from for
var seen_flee: bool = false
var has_physics_this_turn: bool = false


func _ready():
	TurnMaster.connect("prime_physics", Callable(self, "set").bind("has_physics_this_turn", true))


func _physics_process(_delta):
	if has_physics_this_turn:
		return
	
	things_seen = state_owner.look()
	
	if get_script().get_path() != "res://state/npc_states/flee.gd":
		seen_flee = false
		for thing in things_seen:
			if thing.flee_from_debug:
				seen_flee = true
				break
		
		if seen_flee:
			flee_streak += 1
		
		if flee_streak > state_owner.reaction_speed:
			flee_streak = 0
			state_machine.push_state("flee")
