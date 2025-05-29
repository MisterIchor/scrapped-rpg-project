extends PanelContainer

onready var input : LineEdit = ($VBoxContainer/TextInput as LineEdit)
onready var input_history : ItemList = ($VBoxContainer/TextInput/InputHistory as ItemList)



func _ready() -> void:
	input.connect("text_entered", self, "_on_TextInput_text_entered")


#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("toggle_console"):
#		set_visible(!is_visible())
#		input.grab_focus()



func _convert_string_to_value(value : String):
	if value.is_valid_integer():
		return int(value)
	
	if value.is_valid_float():
		return float(value)
	
	if value.begins_with("(") and value.ends_with(")"):
		var x : float = float(value.substr(value.find("(") + 1, value.find(",")))
		var y : float = float(value.substr(value.find(" "), value.find_last(")") - 1))
		
		return Vector2(x, y)
	
	if value.matchn("true"):
		return true
	
	if value.matchn("false"):
		return false
	
	return value


func _parse_text(text : String) -> Array:
	var arguments : Array = []
	var idx : int = 0

	while idx < text.length():
		match text[idx]:
			" ":
				arguments.append(text.substr(0, idx))
				text.erase(0, idx + 1)
				idx = 0
			"(":
				var right_bracket : int = text.find(")") + 1
				
				arguments.append(text.substr(0, right_bracket))
				text.erase(0, right_bracket)
				idx = 0
			_:
				idx += 1
	
	var converted_arguments : Array = []
	
	for i in arguments:
		converted_arguments.append(_convert_string_to_value(i))
	
	return converted_arguments



func _on_TextInput_text_entered(new_text : String) -> void:
	if new_text.length():
		var parsed_text : Array = _parse_text(new_text)
		
		if parsed_text.size() >= 2:
			var node_name : String = parsed_text.pop_front()
			var function : String = parsed_text.pop_front()
			
			ConsoleSystem.call_function(node_name, function, parsed_text)
