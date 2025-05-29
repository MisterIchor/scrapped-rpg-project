extends ItemTemplate
class_name WeaponTemplate

export (float) var speed : float = 1
export (int, -1) var damage : int = 0
export (Resource) var damage_type : Resource
export (int) var critical_chance : int
export (int) var handling : int
export (int) var penetration : int
export (float) var length : float
export (Array) var special : Array



func _init() -> void:
	display_exceptions.append_array([
		"special"
	])
	slots_occupied.hand_left = true
	slots_occupied.hand_right = true
