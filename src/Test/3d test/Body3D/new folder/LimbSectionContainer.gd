extends ValueTracker
class_name LimbSectionContainer



func _init() -> void:
	add_value("injuries", [])
	add_value("equipped_item", null)
	enable_parser(true, 0)
	set_process_changed_values(true)
	set_parser_instructions(load("res://src/Global/Parser/Instructions/Calculate.gd").new())




func _notification(what: int) -> void:
	if what == NOTIFICATION_TEMPLATE_SET:
		if not is_parser_enabled():
			yield(self, "owner_set")
		
		clear_parser_data()
		add_data_to_parser({
			type = "arithmetic_with_stat",
			container_name = "health",
			value_name = "max",
			operation = "multiply",
			percentage_of_value = template.percentage_of_health * 100,
		})



func _calculate_values() -> void:
	if not is_parser_enabled():
		yield(self, "owner_set")
	
	run_parser()
	
	if get("base") == get("max"):
		set("max", get_parser_output())
		set("base", get_parser_output())
	else:
		var old_percentage : float = get_base_percentage()
		
		set("max", get_parser_output())
		set("base", get("max") * old_percentage)



func _on_changed_value_sent(container_name : String, value_name : String, value_new, value_old) -> void:
	if container_name == "health" and value_name == "max":
		_calculate_values()
