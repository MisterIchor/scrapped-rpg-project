extends Movable



func _draw() -> void:
	draw_rect(Rect2(Vector2(), rect_size), Color.white, false)
	draw_rect(Rect2((rect_size / 2) - Vector2(32, 32), Vector2(64, 64)), Color.white, false)
	draw_circle(rect_size / 2, 3, Color.white)
