tool
extends Label
class_name ScrollingText

export (bool) var is_scrolling : bool = true setget set_is_scrolling
export (float) var scroll_speed : float = 125
export (bool) var start_empty : bool = false

var dupe : Label = duplicate(0)
var _font_adj : float = 0



func _ready() -> void:
	var parent : Node = get_parent()
	
	if parent is Control:
		yield(get_tree(), "idle_frame")
		parent.add_child(dupe)
		
		if start_empty:
			rect_position.x -= _font_adj
			dupe.rect_position.x -= rect_size.x + _font_adj
		
		dupe.rect_position.x -= rect_size.x


func _set(property: String, value) -> bool:
	if property == "text":
		text = value
		dupe.text = value
		_font_adj = get_font("font").get_string_size(text).x
	
	return true


func _process(delta: float) -> void:
	rect_position.x += delta * scroll_speed
	dupe.rect_position.x += delta * scroll_speed
	
	if rect_position.x >= rect_size.x:
		rect_position.x -= rect_size.x + rect_position.x
	
	if dupe.rect_position.x >= dupe.rect_size.x:
		dupe.rect_position.x -= rect_size.x + dupe.rect_position.x



func reset_scroll() -> void:
	rect_position.x = -_font_adj
#	dupe.rect_position.x = -rect_size.x



func set_is_scrolling(value : bool) -> void:
	is_scrolling = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	if not is_scrolling:
		reset_scroll()
	
	set_process(is_scrolling)
