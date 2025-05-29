extends DataContainer



func _init() -> void:
	set_name("SoulModifiers")
	set_process_changed_values(true)
	add_value("modifiers", [])



func _on_Container_value_changed(container_name : String, value_name : String, value_new, value_old) -> void:
	if value_name == "modifiers":
		
