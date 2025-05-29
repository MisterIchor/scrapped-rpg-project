extends "../Consumables.gd"



func _init() -> void:
	add_value("satiation", -1)



func set_satiation(new_satiation : int) -> void:
	set("satiation", new_satiation)



func get_satiation() -> int:
	return get("satiation")
