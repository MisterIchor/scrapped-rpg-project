extends Resource
class_name BaseConditionTemplate

var _instructions : GDScript = load("res://src/Global/Parser/Instruction.gd")



func get_condition_properties() -> Dictionary:
	var properties : Dictionary = {}
	
	for i in get_script().get_script_property_list():
		properties[i.name] = get(i.name)
	
	return properties
