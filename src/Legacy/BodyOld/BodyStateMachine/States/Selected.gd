extends "res://src/StateMachine/State.gd"



func _enter() -> void:
	LogSystem.write_to_debug(str(owner.soul.name, " is selected"))


func _handle_input(event : InputEvent) -> void:
	if event.is_action_pressed("select"):
		get_parent().path_finder.request_path()
	
	if event.is_action_pressed("turn"):
		emit_signal("state_finished", "turning")


func _handle_key_input(event) -> void:
	if event.is_action_pressed("space_bar"):
		emit_signal("state_finished", "moving")
	
	if event.is_action_pressed("next_turn"):
		BattleSystem.next_turn()
	
	if event.is_action_pressed("stand_up"):
		get_parent().path_follower.set_stance("standing")
	
	if event.is_action_pressed("crouch"):
		get_parent().path_follower.set_stance("crouching")
	
	if event.is_action_pressed("prone"):
		get_parent().path_follower.set_stance("prone")
	
	if event.is_action_pressed("reload"):
		return
	
	if event.is_action_pressed("run"):
		return
