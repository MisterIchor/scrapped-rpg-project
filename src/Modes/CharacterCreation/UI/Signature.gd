tool
extends VBoxContainer

var text : String = "" setget set_text
var _default_size : int = -1

onready var top_label: Label = $TopLabel
onready var bottom_label: Label = $BottomLabel




func set_text(new_text : String) -> void:
	if text == new_text:
		return
	
	text = new_text
	top_label.text = text
	yield(get_tree(), "idle_frame")
	
	if top_label.get_visible_line_count() > 1:
		var shortened_text : String = ""
		var split : Array = text.split(" ")
		
		shortened_text += split[0][0]
		shortened_text += ". "
		shortened_text += split[1]
		top_label.text = shortened_text
		
#		top_label.text = split[0]
#		top_label.align = Label.ALIGN_LEFT
#		top_label.get_font("font").size -= 2
#		bottom_label.text = split[1]
#		bottom_label.get_font("font").size /= 2
#		bottom_label.show()
