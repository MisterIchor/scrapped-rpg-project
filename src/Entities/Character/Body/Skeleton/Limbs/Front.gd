extends Node2D

signal position_changed(new_position)



func _set(property: String, value) -> bool:
	if property == "position":
		position = value
#		emit_signal("position_changed", value)
		return true
	
	return false
