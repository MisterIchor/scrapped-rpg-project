extends Navigation2D

var astar : AStar2D = AStar2D.new()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print(get_simple_path(Vector2(0, 0), get_global_mouse_position()))
		update()


func _draw() -> void:
	draw_polyline(get_simple_path(Vector2(0,0), get_global_mouse_position()), Color.white)
