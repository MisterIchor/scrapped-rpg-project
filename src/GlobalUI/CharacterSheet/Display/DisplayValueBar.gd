extends "DisplayContainerValue.gd"


onready var bar : ProgressBar = ($HBoxContainer/ProgressBar as ProgressBar)



func _ready() -> void:
	value_label = $HBoxContainer/ProgressBar/ValueLabel
	value_label.connect("incremented", self, "_on_ValueDisplay_incremented")



func _update_text() -> void:
	var shortened_name : String = container.get("shortened_name")
	
	if not shortened_name.empty():
		value_name_label.text = str(shortened_name, ":")
	else:
		value_name_label.text = str(container.name, ":")
	
	if not value_to_show.empty():
		var value_current : int = container.get(value_to_show)
		var value_max : int = container.get("max")
		
		bar.max_value = value_max
		bar.value = value_current
		value_label.max_value = value_max
		value_label.increment_to(value_current)
		container.connect("value_changed", self, "_on_container_value_changed")
		name = container.name



func _on_ValueDisplay_incremented(new_value : int) -> void:
	bar.value = new_value
