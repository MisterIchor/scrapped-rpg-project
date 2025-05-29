extends Button

signal tab_selected(tab)



func _ready() -> void:
	connect("button_up", self, "_on_TabButton_up")



func set_tab_name(new_name : String) -> void:
	text = new_name



func get_tab_size() -> Vector2:
	return rect_size



func _on_TabButton_up() -> void:
	emit_signal("tab_selected", self)
