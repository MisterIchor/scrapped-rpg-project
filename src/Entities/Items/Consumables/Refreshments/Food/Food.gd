extends "../Refreshments.gd"
class_name Food



func _init() -> void:
	add_value("type_food", "") # i.e. meat, grain, etc. Used to determine whether a creature can eat it according to its diet.



func _set_food_type(new_type : String) -> void:
	set("type_food", new_type)



func get_food_type() -> String:
	return get("type_food")
