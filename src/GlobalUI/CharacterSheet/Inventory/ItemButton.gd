extends Button

var item : Item = null setget set_item


func set_item(new_item : Item) -> void:
	item = new_item

	if new_item.icon:
		set_text("")
		icon = new_item.icon
	else:
		set_text(new_item.name)
