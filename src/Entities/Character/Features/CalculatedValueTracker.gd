extends ValueTracker
class_name CalculatedValueTracker



func _init() -> void:
	set_process_changed_values(true)
	enable_parser(true, 0)
	set_parser_instructions(load("res://src/Global/Parser/Instructions/Calculate.gd").new())


func _notification(what: int) -> void:
	._notification(what)
	if what == NOTIFICATION_GET_DATA:
		var values_in_formula : PoolStringArray = []
		
		for i in get("formula"):
			if i.has("container_name"):
				values_in_formula.append(i.container_name)
		
		_data_to_send.merge({
			attribute_bonus = get_parser_output(),
			affected_by = values_in_formula
			})



func _on_changed_value_sent(container_name : String, _value_name : String, _value_new, value_old) -> void:
	if container_name == name:
		return
	
	for i in get("formula"):
		if i.has("container_name"):
			if i.container_name.matchn(container_name):
				_calculate_values()
				break
