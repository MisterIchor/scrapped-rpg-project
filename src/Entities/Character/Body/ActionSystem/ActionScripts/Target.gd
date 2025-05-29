extends ActionScript

var target : Unit = null
var finish_on_move_completion : bool = false
var dir : float = 0.0
var last_point : Vector2 = Vector2()
var has_target : bool = false
var wait_time : float = 0.0



func _init() -> void:
	selected_instructions = "Click on the unit you want this unit to target. Hold CRTL to have this unit automatically target the closest unit instead."
	add_configurable_value("finish_on_move_completion")



func _start() -> void:
	if finish_on_move_completion:
		var move : ActionScript = get_script_from_current_action("Move")
		
		if move:
			move.connect("finished", self, "_on_Move_finished")


func _selected(event : InputEvent) -> void:
	if event.is_action_pressed("select"):
		if Input.is_action_pressed("action_modifier"):
			emit_signal("confirmed")
		
		if target:
			dir = get_angle_to_point(target.get_body_position())
			emit_signal("confirmed")


func _handle_draw() -> void:
	if target:
		VisualServer.canvas_item_add_rect(rid, Rect2(target.get_body_position() - Vector2(18, 18), Vector2(36, 36)), Color(0.5, 0, 0, 0.5))
		
		var pointer : PoolVector2Array = [
		Vector2(0, -2),
		Vector2(0, 2),
		Vector2(50, 0)
		]
		
		for i in pointer.size():
			pointer[i] = pointer[i].rotated(dir)
			pointer[i] += get_path_follower().global_position
		
		VisualServer.canvas_item_add_polygon(rid, pointer, [Color.white])
#	if target_closest_unit:
#		VisualServer.canvas_item_add_rect(rid, Rect2(body.get_body_position(), Vector2(32, 32)), Color.red)


func _handle_physics_process(delta : float) -> void:
	var tracker : Node2D = get_los_trackers()
	has_target = false
	
	if target and target in tracker.units_unblocked:
		dir = get_angle_to_point(target.get_body_position())
		has_target = true
	else:
		var sorted_units : Array = tracker.get_units_unblocked_distance_sorted()
		
		if not sorted_units.empty():
			for i in sorted_units:
				if not i.type == Unit.UnitType.NEUTRAL:
					if not i.type == body.type:
						dir = get_angle_to_point(i.get_body_position())
						has_target = true
	
	if has_target:
		turn_body_to_dir(dir)
		wait_time = 0.0
	else:
		wait_time += delta
		
		if wait_time >= 2.0:
			mark_as_finished()



func _on_Move_finished(_action : Dictionary) -> void:
	mark_as_finished()
