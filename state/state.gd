class_name State
extends Node

signal exit_state
signal state_concluded()
signal cycle_finished

var cycle_timer: Timer
var cycle_freq: float = 1.0
var is_paused: bool = false

var state_owner
var state_machine
var parameters: Dictionary = {}


func _ready():
	self.connect("cycle_finished", Callable(self, "cycle"))
	state_machine = get_parent()


func cycle() -> void:
	await get_tree().create_timer(1000).timeout
	emit_signal("cycle_finished")


func enter() -> void:
	cycle_timer = Timer.new()
	cycle_timer.one_shot = true
	add_child(cycle_timer)


func exit() -> void:
	emit_signal("exit_state")
	queue_free()


func pause() -> void:
	is_paused = true
	set_process(false)
	set_physics_process(false)
	#self.process_mode = Node.PROCESS_MODE_DISABLED


func unpause() -> void:
	is_paused = false
	set_process(true)
	set_physics_process(true)
	#self.process_mode = Node.PROCESS_MODE_PAUSABLE


