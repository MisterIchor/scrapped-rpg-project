extends ColorRect






func _process(delta: float) -> void:
	var new_position : Vector2 = Vector2(rand_range(0, get_parent().rect_size.x), 
			rand_range(0, get_parent().rect_size.y))
	var brightness : float = rand_range(0.2, 0.9)

	rect_position = new_position
	color = Color(brightness, brightness, brightness, 0.7)
