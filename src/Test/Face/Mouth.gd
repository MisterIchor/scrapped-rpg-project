tool
extends TextureRect

export (int) var left_side_offset : int = 0 setget set_left_offset
export (int) var right_side_offset : int = 0 setget set_right_offset
export (int) var mid_offset : int = 0 setget set_mid_offset
export (bool) var show_offsets : bool = false setget set_show_offsets
var count : float = 0.0



func _draw() -> void:
	if texture and show_offsets:
		draw_line(Vector2(left_side_offset, 0), Vector2(left_side_offset, 
					texture.get_height()), Color.red)
		draw_line(Vector2(texture.get_width() - right_side_offset, 0), 
					Vector2(texture.get_width() - right_side_offset, 
					texture.get_height()), Color.green)
		draw_line(Vector2(0, mid_offset), Vector2(texture.get_width(), mid_offset), 
					Color.blue)



func set_texture(new_texture : Texture) -> void:
	texture = new_texture



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "SectionOptions",
		type = TYPE_NIL,
		hint_string = "sec_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "sec_amount",
		type = TYPE_INT
	})
	
	property_list.append({
		name = "sec_create_sections",
		type = TYPE_BOOL,
		hint_usage = PROPERTY_USAGE_CHECKABLE
	})
	
	return property_list



func set_left_offset(new_offset : int) -> void:
	left_side_offset = new_offset
	update()


func set_right_offset(new_offset : int) -> void:
	right_side_offset = new_offset
	update()


func set_mid_offset(new_offset : int) -> void:
	mid_offset = new_offset
	update()


func set_show_offsets(value : bool) -> void:
	show_offsets = value
	update()
