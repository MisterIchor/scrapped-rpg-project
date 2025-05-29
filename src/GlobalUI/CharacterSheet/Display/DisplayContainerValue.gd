extends PanelContainer

var container : DataContainer = null setget set_container
var value_to_show : String = "" setget set_value_to_show

onready var value_name_label: Label = get_node_or_null("HBoxContainer/ValueNameLabel")
onready var value_label: Label = get_node_or_null("HBoxContainer/ValueLabel")



func _update_text() -> void:
	value_name_label.text = container.name.capitalize() + ":"
	value_label.text = str(container.get(value_to_show)) if container else "undefined"



func set_container(new_container : DataContainer) -> void:
	if container:
		container.disconnect("value_changed", self, "_on_Container_value_changed")
	
	container = new_container
	name = container.name
	container.connect("value_changed", self, "_on_Container_value_changed")
	_update_text()


func set_value_to_show(value_name : String) -> void:
	value_to_show = value_name
	_update_text()



func _on_Container_value_changed(value_name : String, new_value, old_value) -> void:
	if value_name == value_to_show:
		_update_text()
