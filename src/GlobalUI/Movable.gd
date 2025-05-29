extends Control
class_name Movable

export (bool) var allow_zoom : bool = false
export (bool) var mouse_focus_required : bool = false setget set_mouse_focus_required
export (float) var max_zoom : float = 1.0
export (float) var min_zoom : float = 0.5
export (float) var zoom_scale : float = 0.01
export (String, "NONE","INSIDE", "OUTSIDE") var clamp_type : String = "NONE"
export (String, "CENTER_ON_MOUSE", "RELATIVE") var grab_type : String = "CENTER_ON_MOUSE"
# Use Control.CursorShape to determine appearance when grabbing
export (bool) var invisible_on_grab : bool = true

var _relative_pos : Dictionary = {rect = Vector2(), mouse = Vector2()}



#func _init() -> void:
#	rect_pivot_offset = rect_size / 2


func _ready() -> void:
	if mouse_focus_required:
		set_process_input(false)
	
	if clamp_type == "NONE":
		set_physics_process(false)



func _input(event : InputEvent) -> void:
	match grab_type:
		"CENTER_ON_MOUSE":
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				rect_global_position = get_global_mouse_position() - get_center()
		
		"RELATIVE":
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				if not _relative_pos.mouse:
					_relative_pos.mouse = get_global_mouse_position()
				
				if not _relative_pos.rect:
					_relative_pos.rect = rect_global_position - get_position_offset()
				
				rect_position = _relative_pos.rect + (get_global_mouse_position() - _relative_pos.mouse)
			else:
				for i in _relative_pos:
					_relative_pos[i] = Vector2()
	
	if invisible_on_grab:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if allow_zoom:
		var scroll : Dictionary = {
		up = Input.is_mouse_button_pressed(BUTTON_WHEEL_UP),
		down = Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN)
		}
		
		if scroll.up:
			rect_scale += Vector2(zoom_scale, zoom_scale)
		elif scroll.down:
			rect_scale -= Vector2(zoom_scale, zoom_scale)
		
		if true in scroll.values():
			rect_scale.x = clamp(rect_scale.x, min_zoom, max_zoom)
			rect_scale.y = clamp(rect_scale.y, min_zoom, max_zoom)



func _physics_process(_delta : float) -> void:
	if not clamp_type == "NONE":
		_clamp_rect_position_inside_parent()



func _clamp_rect_position_inside_parent() -> void:
	var offset : Vector2 = get_position_offset()
	var parent_size : Vector2 = get_parent().rect_size if get_parent() is Control else get_viewport().get_size()
	var max_pos : Vector2 = (parent_size - get_scaled_size()) - offset
	
	rect_position.x = clamp(rect_position.x, -offset.x, max_pos.x)
	rect_position.y = clamp(rect_position.y, -offset.y + 1, max_pos.y - 1)


func _clamp_rect_position_outside_parent() -> void:
	return



func set_mouse_focus_required(value : bool) -> void:
	mouse_focus_required = value
	set_process_input(!mouse_focus_required)
	
	if mouse_focus_required:
		if not is_connected("gui_input", self, "_input"):
			connect("gui_input", self, "_input")
	elif is_connected("gui_input", self, "_input"):
		disconnect("gui_input", self, "_input")



func get_center() -> Vector2:
	return (get_scaled_size() / 2) + get_position_offset()


func get_global_position_adjusted() -> Vector2:
	return rect_global_position - get_position_offset()


func get_position_offset() -> Vector2:
	return rect_pivot_offset - (rect_pivot_offset * rect_scale)


func get_scaled_size() -> Vector2:
	return rect_size * rect_scale

