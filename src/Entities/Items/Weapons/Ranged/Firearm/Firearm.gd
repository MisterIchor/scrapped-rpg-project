extends "../RangedWeapon.gd"



func _init() -> void:
	add_value("recoil", -1)
	add_value("jam_chance", -1)
	add_value("fire_types", [])
	add_value("fire_rate", 1)



func set_recoil(new_recoil : int) -> void:
	set("recoil", new_recoil)



func get_recoil() -> int:
	return get("recoil")
