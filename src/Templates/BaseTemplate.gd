extends Resource
class_name BaseTemplate

export (String) var name : String = String() setget , get_name
export (String, MULTILINE) var description : String = String()



func set(property : String, value) -> void:
	emit_signal("changed")
	.set(property, value)


func get_name() -> String:
	return name


func get_template_properties() -> Dictionary:
	var properties : Dictionary = {}
	var property_list : Array = get_script().get_script_property_list()
	
	for i in property_list:
		properties[i.name] = {value = get(i.name), hint = i.hint}
	
	return properties
