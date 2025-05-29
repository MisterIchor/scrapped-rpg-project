extends CalculatedValueTracker
class_name Stat



func _init() -> void:
	set("max", 0)
	set("current", 0)


func _calculate_values() -> void:
	clear_parser_data()
	set_parser_output(0)
	
	for i in get("formula"):
		add_data_to_parser(i)
	
	run_parser()
	set("attribute_bonus", get_parser_output())
	
	var new_max : int = 0
	
	new_max += get("base")
#	new_max += get("attribute_bonus")
	
	if get("current") == get("max"):
		set("max", new_max)
		set("current", new_max)
	else:
		var old_percentage : float = get_percentage()
		
		set("max", new_max)
		set("current", get("max") * old_percentage)
