extends ActionScript
#class_name LookAction

var dir : float = 0.0



func _init() -> void:
	selected_instructions = "Place the cursor in the direction you want this unit to look."



func _preview() -> void:
	dir = -PI / 4


func _selected(event : InputEvent) -> void:
	dir = get_angle_to_point(get_mouse_position())
	
	if event.is_action_pressed("select"):
		emit_signal("confirmed")


func _handle_draw() -> void:
	var pointer : PoolVector2Array = [
		Vector2(0, -2),
		Vector2(0, 2),
		Vector2(50, 0)
		]
	
	for i in pointer.size():
		pointer[i] = pointer[i].rotated(dir)
		pointer[i] += get_path_follower().global_position
	
	VisualServer.canvas_item_add_polygon(rid, pointer, [Color.white])



func _handle_physics_process(_delta : float) -> void:
	var target_script : ActionScript = get_script_from_current_action("Target")
	
	if target_script:
		if target_script.has_target:
			return
	
	turn_body_to_dir(dir)
	
	if is_equal_approx(get_path_follower().rotation, dir):
		mark_as_finished()
