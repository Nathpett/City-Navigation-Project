extends Sprite2D

var true_parent


func _ready():
	true_parent = get_parent()
	call_deferred("_become_sibling")


func _process(_delta) -> void:
	var t = _delta * 8
	position = position.lerp(true_parent.global_position, t)


func _become_sibling() -> void:
	get_parent().remove_child(self)
	true_parent.get_parent().add_child(self)
	position = true_parent.global_position


