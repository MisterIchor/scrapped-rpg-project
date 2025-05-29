extends "../Item.gd"



func _init() -> void:
	add_value("uses", -1)



func set_uses(new_amount : int) -> void:
	set("uses", new_amount)



func get_uses() -> int:
	return get("uses")
