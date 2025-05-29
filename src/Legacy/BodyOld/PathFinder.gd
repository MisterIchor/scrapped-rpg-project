extends Path2D

var path : Array = []
var path_color : Color = Color(0, 0, 1)

signal path_requested(point_one, point_two)

onready var path_follower : PathFollow2D = ($PathFollower as PathFollow2D)



func _ready() -> void:
	path_follower.connect("point_reached", self, "_on_PathFollower_point_reached")


func _draw() -> void:
	for i in path:
		draw_circle(i, 3, Color(1, 0, 0))
	
	if get_path_size() >= 2:
		draw_polyline(path, Color(1, 0, 0), 2)



func request_path(point_one : Vector2, point_two : Vector2) -> void:
	emit_signal("path_requested", point_one, point_two)


func update_path() -> void:
	curve.clear_points()
	
	for i in path:
		curve.add_point(i)
	
	update()


func add_path(new_path : Array) -> void:
	path.append(remove_points_on_path(new_path))
	update_path()



func remove_points_on_path(path_to_remove : Array) -> Array:
	var new_path : Array = path
	
	for i in path_to_remove:
		if i in new_path:
			new_path.erase(i)
	
	return new_path


func next_point() -> void:
	update_path()



func get_path_size() -> int:
	return path.size()


func get_next_direction() -> Vector2:
	return Vector2()



func _on_PathFollower_point_reached(_new_position : Vector2) -> void:
	next_point()


func _on_path_sent(new_path : Array) -> void:
	add_path(path)
