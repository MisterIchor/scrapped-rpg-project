extends "res://src/StateMachine/State.gd"



func _enter() -> void:
	LogSystem.write_to_debug(str(owner.soul.name, " is auto-turning"))
	get_parent().path_follower.turn(get_parent().path_finder.get_next_direction())
