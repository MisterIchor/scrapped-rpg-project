extends "res://src/StateMachine/State.gd"



func _enter() -> void:
	LogSystem.write_to_debug(str(owner.soul.name, " is turning"))
	get_parent().path_follower.turn()
