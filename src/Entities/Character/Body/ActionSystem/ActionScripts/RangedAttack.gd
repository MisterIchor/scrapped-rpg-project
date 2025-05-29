extends ActionScript

var accuracy_to_attack : float = 0.8



func _init() -> void:
	add_configurable_value("accuracy_to_attack")



func _selected(event : InputEvent) -> void:
	if event.is_action_pressed("select"):
		var target = get("target")
		if target:
			if target is Unit:
				target = target.get_body_position()
			
			var area : Rect2 = Rect2(target - (target / 4), target)
			print(area)
			
			if area.has_point(get_mouse_position()):
				emit_signal("action_confirmed")
		
		set("target", get_mouse_position())


func _handle_draw() -> void:
	if get("target"):
		VisualServer.canvas_item_add_circle(get("rid"), get("target"), 8, Color(1.0, 0.0, 0.0, 0.5))


func _handle_process(_delta : float) -> void:
	if not get("target"):
		set("target_closest", get_closest_target())



func _handle_physics_process(_delta : float) -> void:
	var target = get("target")
	
	# Target can either be Unit or Vector2.
	if target:
		if target is Unit:
			get_path_follower().look_at(target.get_body_position())
		else:
			get_path_follower().look_at(target)
	if get("target_closest"):
		get_path_follower().look_at(get("target_closest").get_body_position())



func get_closest_target() -> Unit:
	var units_unblocked : Array = get_los_trackers().units_unblocked
	
	if units_unblocked.empty():
		return null
	
	var closest_target : Unit = units_unblocked.pop_front()
	var pos : Vector2 = get_path_follower().global_position
	
	for i in get_los_trackers().units_unblocked:
		if i.distance_squared_to(pos) < closest_target.distance_squared_to(pos):
			closest_target = i
	
	return closest_target


func get_class() -> String:
	return "AttackAction"
