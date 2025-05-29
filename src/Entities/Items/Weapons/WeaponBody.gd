extends "../ItemBody.gd"

onready var weapon_length : Tracker = ($RayCast2D as Tracker)



func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		weapon_length.cast_to.x = container.get("length")


func _attack() -> void:
	return



func attack() -> void:
	_attack()
