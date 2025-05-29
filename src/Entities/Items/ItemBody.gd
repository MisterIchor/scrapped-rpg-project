extends BaseBody



func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		set_name(container.name + "ItemBody")
