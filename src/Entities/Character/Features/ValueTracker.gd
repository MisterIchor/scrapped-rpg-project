extends TemplateContainer
class_name ValueTracker



func _init() -> void:
	add_value("current", 50)
	add_value("base", 50)
	add_value("max", 100)
	add_value("modifiers", [])
	connect("template_set", self, "_calculate_values")


func _set(property : String, value) -> bool:
	if property == "base":
		set("current", value)
	
	return ._set(property, value)



func _calculate_values() -> void:
	return



func add_modifier(modifier_to_add : ModifierTemplate) -> void:
	append_to_array("modifiers", modifier_to_add)



func get_percentage() -> float:
	if get("max") == 0 or get("current") == 0:
		return 0.0
	
	return float(get("current")) / float(get("max"))


func get_base_percentage() -> float:
	if get("max") == 0 or get("base") == 0:
		return 0.0
	
	return float(get("base")) / float(get("max"))
