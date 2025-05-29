extends Action



func _handle_input(event : InputEvent) -> void:
	if event.is_action_pressed("select"):
		var point_one : Vector2 = get_path_follower().get_global_position()
		var point_two : Vector2 = get_path_finder().get_global_mouse_position()
		
#		if get_path_finder().path_current.front():
#			point_one = get_path_finder().path_current.front()
		
		get_path_finder().request_path(point_one, point_two)


#func _handle_key_input(event : InputEventKey) -> void:
#	if event.is_action_pressed("space_bar"):
#		emit_signal("state_finished", "move")
#
#	if event.is_action_pressed("stand_up"):
#		get_path_follower().set_stance("standing")
#
#	if event.is_action_pressed("crouch"):
#		get_parent().path_follower.set_stance("crouching")
#
#	if event.is_action_pressed("prone"):
#		get_parent().path_follower.set_stance("prone")
#
#	if event.is_action_pressed("reload"):
#		return
#
#	if event.is_action_pressed("run"):
#		return
