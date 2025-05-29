extends Path2D

var path_actual : Array = []
var path_mapped : Array = []
var path_current : Array = []
var path_color : Color = Color(0, 0, 1)

signal path_requested(point_one, point_two, node)
signal point_reached
signal last_point_reached

onready var path_follower : PathFollow2D = ($PathFollower as PathFollow2D)
onready var state_machine : Node = ($PathFollower/StateMachine as Node)



func _ready() -> void:
	path_follower.connect("point_reached", self, "_on_PathFollower_point_reached")
#	state_machine.path_finder = self
#	state_machine.path_follower = path_follower


func _draw() -> void:
	for i in path_actual:
		draw_circle(i, 3, path_color)
	
	for i in path_current:
		draw_circle(i, 3, Color(1, 0, 0))
	
	if get_mapped_size() >= 2:
		var a : Array = path_mapped.duplicate(true)
		a.push_front(path_current[1])
		draw_polyline(a, path_color, 2)
	
	if get_current_size() >= 2:
		draw_polyline(path_current, Color(1, 0, 0), 2)



func clear_all_paths() -> void:
	path_actual.clear()
	path_mapped.clear()
	path_current.clear()
	curve.clear_points()
	update()


func request_path() -> void:
	var point_one : Vector2 = path_follower.global_position
	var point_two : Vector2 = path_follower.get_global_mouse_position()
	
	if not Input.is_action_pressed("add_to_path"):
		clear_all_paths()
	elif get_actual_size():
		point_one = path_actual[-1]
	
	emit_signal("path_requested", point_one, point_two)


func update_path() -> void:
	curve.clear_points()
	
	for i in path_current:
		curve.add_point(i)
	
	update()


func add_path(actual : Array, mapped : Array) -> void:
	if get_actual_size():
		if actual[1] == path_actual[-1]:
			return
	
	if get_current_size():
		mapped.pop_front()
	
	path_mapped += mapped
	path_actual += actual
	
	optimized_all_paths()
	
	if not get_current_size():
		var point_one : Vector2 = path_mapped.pop_front()
		var point_two : Vector2 = path_mapped.pop_front()
		path_actual.pop_front()
		
		path_current.append(point_one)
		path_current.append(point_two)
	
	update_path()


func optimized_all_paths() -> void:
	path_mapped = optimize_path(path_mapped)
	path_actual = optimize_path(path_actual)


func optimize_path(path : Array) -> Array:
	var idx : int = 1
	
	while not idx == path.size():
		if path[idx] == path[idx - 1]:
			path.remove(idx)
			idx -= 1
		idx += 1
	
	return path


func remove_points_on_path(path : Array, start : int, end : int) -> Array:
	var new_mapped_path : Array = path.duplicate(true)
	new_mapped_path.invert()
	
	for i in range(end, start, -1):
		new_mapped_path.remove(i)
	
	new_mapped_path.invert()
	return new_mapped_path


func next_point() -> void:
	if not get_mapped_size() > 0:
		return
	
	var point : Vector2 = path_mapped.pop_front()
	
	if path_actual.front() == path_current.front():
		path_actual.pop_front()
	
	path_current.pop_front()
	path_current.append(point)
	
	update_path()



func get_actual_size() -> int:
	return path_actual.size()


func get_current_size() -> int:
	return path_current.size()


func get_mapped_size() -> int:
	return path_mapped.size()


func get_next_direction() -> Vector2:
	if get_mapped_size():
		return path_mapped.front().back()
	return Vector2()



func _on_PathFollower_point_reached(_new_position : Vector2) -> void:
	if get_mapped_size() == 0:
		clear_all_paths()
		emit_signal("last_point_reached")
	else:
		next_point()


func _on_path_sent(actual_path : Array, mapped_path : Array) -> void:
	add_path(actual_path, mapped_path)
