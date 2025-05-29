extends "res://src/StateMachine/State.gd"



func _enter() -> void:
	LogSystem.write_to_debug(str(owner.soul.name, " is moving"))
	
	if not get_parent().path_follower._dir_current == get_parent().path_finder.get_next_direction():
		emit_signal("state_finished", "auto_turning")


func _handle_process(delta : float) -> void:
	get_parent().path_follower.move()


func _handle_key_input(event : InputEventKey) -> void:
	if event.is_action_pressed("space_bar"):
		emit_signal("state_finished", "selected")
