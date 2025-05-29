extends ColorRect

onready var move_limit : Vector2 = get_viewport().get_size()
onready var current_pos : Vector2 = get_viewport().get_size() / 2
var drag_start : Vector2 = Vector2()
var is_dragging : bool = false



func _gui_input(event: InputEvent) -> void:
	if not is_dragging:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			drag_start = get_global_mouse_position()
			is_dragging = true
	
	if is_dragging:
		var mouse_pos : Vector2 = get_global_mouse_position()
		var x : float = (mouse_pos.x - drag_start.x) + current_pos.x
		var y : float = (mouse_pos.y - drag_start.y) + current_pos.y
		
		rect_global_position.x = clamp(x, -(rect_size.x - move_limit.x), 0)
		rect_global_position.y = clamp(y, -(rect_size.y - move_limit.y), 0)
		prints(get_global_position(), get_global_mouse_position(), drag_start, has_focus())
		
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			current_pos = get_global_position()
			is_dragging = false
			
