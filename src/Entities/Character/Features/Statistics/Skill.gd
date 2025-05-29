extends CalculatedValueTracker
class_name Skill



func _init():
	add_value("unlockable_abilities", {})



func _calculate_values() -> void:
	clear_parser_data()
	set_parser_output(0)
	
	for i in get("formula"):
		add_data_to_parser(i)
	
	run_parser()
#	set("attribute_bonus", get_parser_output())
	set("current", 0)
	increment_value("current", get("base"))
#	increment_value("current", get("points_added"))
#	increment_value("current", get("attribute_bonus"))
	set_clamped("current", get("current"), 0, get("max"))



func get_new_abilities(current_skill : int) -> Array:
	var new_abilities : Array = []
	
	for i in get_unlockable_abilities():
		if current_skill > i:
			new_abilities.append(get_unlockable_abilities()[i])
	
	return new_abilities


func get_unlockable_abilities() -> Dictionary:
	return get("unlockable_abilities")
