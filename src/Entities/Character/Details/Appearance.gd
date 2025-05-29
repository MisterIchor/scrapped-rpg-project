extends DataContainer



func _init():
	set_name("Appearance")
	add_value("custom_portrait", load("res://assets/graphics/character_creation/ShaIcon.png"))
	add_value("background", null)
	add_value("head", null)
	add_value("eyes", null)
	add_value("mouth", null)
	add_value("hair_color", Color.magenta)
	add_value("eye_color", Color.magenta)



#func _set(value_name : String, value) -> bool:
#	if typeof(value) == TYPE_STRING:
#		if not value.is_abs_path():
#			return false
#
#	return ._set(value_name, value)
