extends PanelContainer

onready var value_name_label: Label = $HBoxContainer/ValueNameLabel
onready var value_label: Label = $HBoxContainer/ValueLabel



func set_value_name(text : String) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	
	value_name_label.text = str(text.capitalize(), ":")


func set_value(value) -> void:
	var value_string : String = String()
	
	match typeof(value):
		TYPE_STRING_ARRAY:
			for j in value:
				value_string += j.capitalize()
				
				if not j == value[-1]:
					value_string += "\n"
		TYPE_INT, TYPE_REAL:
			value_string = str(value)
	
	if not is_inside_tree():
		yield(self, "ready")
	
	value_label.text = value_string
