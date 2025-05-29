extends HBoxContainer

var item : Item = null setget set_item

onready var icon : TextureRect = ($Icon as TextureRect)
onready var item_name : Label = ($ItemName as Label)



func set_item(new_item : Item) -> void:
	item = new_item
	
	if item:
		icon.texture = item.icon
		item_name.text = item.name
