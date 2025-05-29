extends Node2D

var current_pos : Vector2 = Vector2(16, 16)


func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		current_pos = get_global_mouse_position()
	if event is InputEventMouseMotion:
#		print(get_simple_path(current_pos, get_global_mouse_position()))
		update()


func _draw() -> void:
	draw_polyline(get_node("../Navigation2D").get_simple_path(current_pos, get_global_mouse_position(), false), Color.white)
