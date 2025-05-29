tool
extends Label

export (String) var container_name : String = "undefined" setget set_container_name
export (String, "TEXT", "BAR", "TEXT_BAR") var display : String = "BAR" setget set_display



func set_container_name(new_name : String) -> void:
	container_name = new_name
	
	if not Engine.editor_hint:
		set_name(container_name + "Info")
		set_text(container_name.capitalize() + ":")


func set_display(new_display : String) -> void:
	display = new_display
