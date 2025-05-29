extends VBoxContainer

var soul : Soul = null setget set_soul

onready var label_name : Label = ($Name as Label)
onready var label_health : Label = ($Health as Label)
onready var label_stamina : Label = ($Stamina as Label)
onready var label_action_points : Label = ($ActionPoints as Label)
onready var label_is_selected : Label = ($IsSelected as Label)



#func animate_stat(label :)


func update_hud() -> void:
	label_name.set_text(str("Name: ", soul.get_nickname()))
	label_health.set_text(str("Health: ", soul.get_current_health(), "/", soul.get_max_health()))
	label_stamina.set_text(str("Stamina: ", soul.get_current_stamina(), "/", soul.get_max_stamina()))
	label_action_points.set_text(str("Action Points: ", 
			soul.get_current_action_points(), "/", soul.get_max_action_points()))
	label_is_selected.set_text(str("Is Selected: ", soul.is_selected))



func set_soul(new_soul : Soul) -> void:
	if soul:
		soul.disconnect("selection_changed", self, "_on_Soul_selection_changed")
		soul.disconnect("changed_value_sent", self, "_on_Soul_changed_value_sent")
	
	soul = new_soul
	soul.connect("selection_changed", self, "_on_Soul_selection_changed")
	soul.connect("changed_value_sent", self, "_on_Soul_changed_value_sent")
	update_hud()



func _on_Soul_changed_value_sent(container_name : String, value_name : String, data : Dictionary) -> void:
	update_hud()


func _on_Soul_selection_changed(is_selected : bool) -> void:
	update_hud()


func _on_Soul_type_changed(type : String) -> void:
	return
