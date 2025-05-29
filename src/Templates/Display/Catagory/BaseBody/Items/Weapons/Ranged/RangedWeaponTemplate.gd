tool
extends WeaponTemplate
class_name RangedWeaponTemplate

export (Resource) var ammo_type : Resource
export (int, 1, 999) var ammo_capacity : int = 1



func _init() -> void:
	display_exceptions.append_array([
		"ammo_type"
	])
	add_bank("fire")
	_body 
