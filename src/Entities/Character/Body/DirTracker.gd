extends "BaseTracker.gd"

signal unit_collided(unit)



func _physics_process(delta: float) -> void:
	if is_unit_in_way():
		emit_signal("unit_collided", get_collider())



func is_unit_in_way() -> bool:
	var collider = get_collider()
	
	if not collider:
		return false
	
	return get_collider().owner is Unit







