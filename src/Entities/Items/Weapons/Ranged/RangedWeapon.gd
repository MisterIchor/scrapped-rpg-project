extends "../Weapon.gd"



func _init() -> void:
	add_value("ammo_loaded", 0)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TEMPLATE_SET:
		set("ammo_loaded", get("ammo_capacity"))

