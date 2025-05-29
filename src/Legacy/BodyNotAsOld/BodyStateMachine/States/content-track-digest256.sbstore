extends Path2D

var path : Array = []
var path_current : Array = []
var path_color : Color = Color(0, 0, 1)

signal path_requested(point_one, point_two)
signal point_reached(next_point)

onready var path_follower : PathFollow2D = ($PathFollower as PathFollow2D)



func _enter_tree() -> void:
	set_curve(Curve2D.new())


func _ready() -> void:
	path_follower.connect("point_reached", self, "_on_PathFollower_point_reached")


func _draw() -> void:
	if get_current_size() >= 1:
		for i in path_current:
			draw_circle(i, 3, Color(1, 0.5, 0))
	
	if get_current_size() >= 2:
		draw_polyline(path_current, Color(1, 0.5, 0), 2)
	
	if get_path_size() >= 1:
		for i in path:
			draw_circle(i, 3, Color(1, 0, 0))
		
		var full_path : Array = path.duplicate()
		
		full_path.push_front(path_current.back())
		draw_polyline(full_path, Color(1, 0, 0), 2)



func request_path(point_one : Vector2, point_two : Vector2) -> void:
	emit_signal("path_requested", point_one, point_two)


func update_path() -> void:
	curve.clear_points()
	
	for i in path_current:
		curve.add_point(i)
	
	update()


func add_path(new_path : Array) -> void:
	path = new_path
	
	if path_current.empty() or path_follower.global_position == path_current.front():
		path_current = [path.pop_front(), path.pop_front()]
#	elif not path_follower.global_position == path_current.front():
#		path_current[0] = path_follower.get_global_position()
	
#	if path.front() == path_current.front():
#		if path[1] == path_current[1]:
#			path.pop_front()
#
#		path.pop_front()
	
	update_path()



func remove_points_on_path(path_to_remove : Array) -> Array:
	var new_path : Array = path
	
	for i in path_to_remove:
		if i in new_path:
			new_path.erase(i)
	
	return new_path



func get_path_size() -> int:
	return path.size()


func get_current_size() -> int:
	return path_current.size()


func get_next_direction() -> Vector2:
	return Vector2()



func _on_PathFollower_point_reached() -> void:
	var next_point : Vector2 = Vector2(-9999, -9999)
	var new_position : Vector2 = path_current.pop_front()
	
	if not path.size() == 0:
		next_point = path.pop_front()
		path_current.append(next_point)
	
	emit_signal("point_reached", new_position, next_point)
	update_path()


func _on_path_sent(new_path : Array) -> void:
	add_path(new_path)
