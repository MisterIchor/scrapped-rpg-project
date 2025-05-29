tool
extends MarginContainer

export (String, "HORIZONTAL", "VERTICAL") var orientation : String = "HORIZONTAL" setget set_orientation
export (bool) var show_separator : bool = false setget set_separator_visibility



func set_text(new_text : String) -> void:
	$Container/Label.set_bbcode(new_text)


func set_orientation(new_orientation : String) -> void:
	if orientation == new_orientation:
		return
	
	orientation = new_orientation
	
	var label : RichTextLabel = get_node("Container/Label")
	var container_current : Container = get_node("Container")
	var container : Container = null
	var separator : Separator = null
	
	container_current.remove_child(label)
	container_current.free()
	
	match orientation:
		"HORIZONTAL":
			container = HBoxContainer.new()
			separator = VSeparator.new()
		
		"VERTICAL":
			container = VBoxContainer.new()
			separator = HSeparator.new()
	
	container.add_child(separator)
	container.add_child(label)
	add_child(container)
	container.owner = self
	container.name = "Container"
	separator.owner = self
	separator.name = "Separator"
	separator.set_visible(show_separator)
	label.owner = self


func set_separator_visibility(value : bool) -> void:
	show_separator = value
	$Container/Separator.set_visible(show_separator)



func get_text() -> String:
	return $Container/Label.get_bbcode()


func get_text_raw() -> String:
	return $Container/Label.get_text()
