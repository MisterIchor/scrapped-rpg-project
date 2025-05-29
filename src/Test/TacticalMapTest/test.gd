extends Navigation2D



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print(get_simple_path(Vector2(16, 16), get_global_mouse_position()))
