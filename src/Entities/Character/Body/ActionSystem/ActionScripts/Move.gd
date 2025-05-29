extends ActionScript

var max_speed : float = 1.0
var current_speed : float = 0.0
var paths : Array = []
var last_point : Vector2 = Vector2()
var point_draw : Array = []
var _path_preview : Array = []
#var _wait_time : float = 0.0
var stop_moving_on_target_acquisition : bool = false



func _init() -> void:
	selected_instructions = "Place a point at a valid position. Hold CTRL to create multiple paths."
	add_configurable_value("max_speed")
	add_configurable_value("stop_moving_on_target_acquisition")



func _start() -> void:
	load_path_to_curve(get_current_path())


func _confirmed() -> void:
	add_path()


func _preview() -> void:
	paths.append(get_walkable_path(get_body_position(), get_body_position() + Vector2(64, 0)))


func _interrupted() -> void:
	get_curve().clear_points()
	get_path_follower().offset = 0.0
	
	if not paths.empty():
		var current_path : Array = get_current_path()
		var idx : int = current_path.find(get_next_closest_point())
		
		paths[0] = current_path.slice(idx, current_path.size() - 1)
		paths[0].push_front(get_path_follower().global_position)
	else:
		mark_as_finished()



func _finished() -> void:
	var next_move_action : ActionScript = get_script_from_last_action("Move")

	if next_move_action:
		next_move_action.current_speed = current_speed

#	if not get_curve_points().empty():
#		get_path_follower().global_position = get_curve_points()[-1]
	
	get_curve().clear_points()
	get_path_follower().offset = 0.0


func _selected(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var start_position : Vector2 = get_path_follower().global_position
		var end_position : Vector2 = get_mouse_position()
		var latest_path : Array = get_latest_path()
		var next_move_action_path : Array = get_next_move_action_path()
		
		if not latest_path.empty():
			start_position = latest_path.back()
		elif not next_move_action_path.empty():
			start_position = next_move_action_path.back()
		
		_path_preview = get_walkable_path(start_position, end_position)
	
	if event.is_action_pressed("select"):
		if Input.is_action_pressed("action_modifier"):
			add_path()
		else:
			emit_signal("confirmed")


func _handle_physics_process(delta : float) -> void:
	if paths.empty():
		return
	
	var path_follower : PathFollow2D = get_path_follower()
	var angle_to_next_point : float = get_angle_to_point(get_next_closest_point() + Vector2(5, 0).rotated(path_follower.rotation))
	var look_at_path : bool = true
	var target_script : ActionScript = get_script_from_current_action("Target")
	
	if get_script_from_current_action("Look"):
		look_at_path = false
	elif target_script:
		if target_script.has_target:
			look_at_path = false
	
	if look_at_path:
		turn_body_to_dir(angle_to_next_point)
	
	if path_follower.unit_offset >= 0.989:
		paths.pop_front()
		
		if not paths.empty():
			load_path_to_curve(paths.front())
		else:
			mark_as_finished()
		
		return
	
	var speed_increment : float = 0.0
	var speed_modifier : float = 1.0
	
	if paths.size() == 1 and get_next_move_action_path().empty():
		var slowdown_offset : float = get_offset_slowdown()
		
		if path_follower.unit_offset >= slowdown_offset:
			speed_modifier = abs(path_follower.unit_offset - 1.0) / slowdown_offset
	
#	if get_dir_tracker().is_unit_in_way():
#		speed_modifier = 0.02
	
	if stop_moving_on_target_acquisition:
		if target_script:
			if target_script.has_target:
				speed_modifier = 0.0
	
	speed_modifier *= 0.5 + (0.5 * get_facing_to_point_ratio(get_next_closest_point()))
	speed_increment = lerp(current_speed, max_speed * speed_modifier, 0.1)
	current_speed = speed_increment
	path_follower.offset += current_speed
#
#	if speed_modifier == 0.0:
#		_wait_time += delta
#	else:
#		_wait_time = 0.0
#
#	if _wait_time >= 2.0:
#		remake_current_path()
#		_wait_time = 0.0


func _handle_draw() -> void:
	var path : Array = get_full_path()
	path.append_array(_path_preview)
	
	if not path.empty() and path.size() > 1:
		var eye_color : Color = get_value_from_container("appearance", "eye_color")
		var hair_color : Color = get_value_from_container("appearance", "hair_color")
		
		VisualServer.canvas_item_add_polyline(rid, path, [eye_color], 2.0)
		
		if not point_draw.empty():
			for i in path.size() - 1:
				var point_draw_rotated : PoolVector2Array = point_draw
				var angle : float = path[i + 1].angle_to_point(path[i])
				
				for j in point_draw_rotated.size():
					point_draw_rotated[j] = point_draw_rotated[j].rotated(angle) + path[i + 1]
				
				VisualServer.canvas_item_add_polyline(rid, point_draw_rotated, [hair_color], 2.0)
		else:
			for i in path:
				if i == path.front() or i == path.back():
					VisualServer.canvas_item_add_circle(rid, i, 3.0, Color.white)
					continue
				
				VisualServer.canvas_item_add_circle(rid, i, 3.0, hair_color)



func add_path() -> void:
	if _path_preview.empty():
		return
	
	var navigation : AStar2D = get_navigation()
	
#	for i in path_preview:
#		var point_id : int = navigation.get_closest_point(i)
#		navigation.set_point_weight_scale(point_id, 1.5)
	
	paths.append(_path_preview.duplicate())
	_path_preview.clear()


func remake_current_path() -> void:
	var navigation : AStar2D = get_navigation()
	var current_path : Array = get_current_path()
	var closest_point : Vector2 = get_next_closest_point()
	var disabled_points : Array = []
	current_path = current_path.slice(current_path.find(closest_point), current_path.size() - 1)
	
	for i in current_path:
		var point_idx : int = navigation.get_closest_point(i)
		navigation.set_point_disabled(point_idx)
		disabled_points.append(point_idx)
	
	paths[0] = get_walkable_path(closest_point, paths[0].back())
	paths[0].push_front(get_path_follower().global_position)
	load_path_to_curve(get_current_path())
	
	for i in disabled_points:
		navigation.set_point_disabled(i, false)


func load_path_to_curve(path : Array) -> void:
	if path.empty():
		return
	
	get_curve().clear_points()
	get_path_follower().offset = 0.0
	get_path_follower().global_position = path.front()
	
	for i in path:
		get_curve().add_point(i)



func is_facing_next_point() -> bool:
	return get_facing_to_point_ratio(get_next_closest_point()) >= 0.98



func get_curve() -> Curve2D:
	return get_path_finder().curve


func get_curve_points() -> PoolVector2Array:
	return get_curve().get_baked_points()


func get_next_closest_point() -> Vector2:
	var path : Array = get_current_path()
	
	if path.empty():
		var next_path : Array = get_next_move_action_path()
		
		if next_path:
			return next_path.front()
		
		return last_point
	
	var path_follower : PathFollow2D = get_path_follower()
	var closest_point : Dictionary = {
		idx = 0,
		distance = path[0].distance_squared_to(path_follower.global_position)
	}
	
	for i in range(1, path.size()):
		var point : Vector2 = path[i]
		var distance : float = point.distance_squared_to(path_follower.global_position)
		
		if not distance < closest_point.distance:
			break
		
		closest_point.idx = i
		closest_point.distance = distance
	
	last_point = path[min(closest_point.idx + 1, path.size() - 1)]
	return last_point


func get_next_move_action_path() -> Array:
	var move_script : ActionScript = get_script_from_last_action("Move")
	
	if not move_script:
		return []
	
	return move_script.get_full_path()



func get_offset_slowdown() -> float:
	if paths.size() > 1:
		return 1.0
	
	var path_ratio : float = 1.0 / max(get_latest_path().size() - 1, 1)
	var offset_slowdown : float = 1.0 - path_ratio
	var base_speed_adj : float = path_ratio * (1.0 - min(max_speed, 1))
	var speed_ratio : float = 1.0 - (current_speed / max_speed)
	var speed_adj : float = 0.99 - (offset_slowdown + base_speed_adj)
	return offset_slowdown + base_speed_adj + (speed_adj * speed_ratio)


func get_full_path() -> Array:
	var full_path : Array = []
	
	for i in paths:
		full_path.append_array(i)
	
	return full_path


func get_current_path() -> Array:
	return paths.front() if not paths.empty() else []


func get_latest_path() -> Array:
	return paths.back() if not paths.empty() else []


func get_walkable_path(point_one : Vector2, point_two : Vector2) -> Array:
	var astar : AStar2D = get_navigation()
	var point_one_index : int = astar.get_closest_point(point_one)
	var point_two_index : int = astar.get_closest_point(point_two)
	var points : Array = astar.get_points()
	
	return astar.get_point_path(point_one_index, point_two_index) as Array


