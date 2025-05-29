extends LineEdit

onready var input_history : ItemList = $InputHistory



func _ready() -> void:
	input_history.connect("prev_input_selected", self, "_on_InputHistory_prev_input_selected")
	connect("text_entered", self, "_on_text_entered")
	connect("text_entered", input_history, "_on_text_entered")
	connect("text_changed", input_history, "_on_text_changed")
	connect("text_changed", self, "_on_text_changed")
	connect("focus_entered", input_history, "_on_focus_entered")
#	connect("focus_exited", input_history, "_on_focus_exited")



func _input(event: InputEvent) -> void:
	if has_focus():
		if event.is_action_pressed("ui_down"):
			return
		
		if event.is_action_pressed("ui_up"):
			return
		
		if event.is_action_pressed("toggle_console"):
			return
#
#		get_tree().set_input_as_handled()



func _on_text_entered(new_text : String) -> void:
	if new_text.empty():
		return
	
	LogSystem.write_to_log("debug", new_text)
	clear()


func _on_InputHistory_prev_input_selected(text : String) -> void:
	var space_index : int = get_text().find(" ")
	
	if space_index:
		var new_text : String = get_text()
		
		new_text.erase(0, space_index + 1)
		set_text(get_text() + text.lstrip(new_text))
	
	grab_focus()
	set_cursor_position(get_text().length())
