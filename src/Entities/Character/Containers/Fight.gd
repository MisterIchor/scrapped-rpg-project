extends DataContainer



func _init() -> void:
	set_process_changed_values(true)
	add_value("accuracy", 100.0)
	add_value("equipped_weapon", null)
	add_value("body", null)



func _on_changed_value_sent(container_name : String, value_name : String, value_new, value_old) -> void:
	if container_name == "BodyInfo" and value_name == "body":
		if value_old:
			value_old.disconnect("tree_exited", self, "_on_Body_tree_exited")
		
		set("body", value_new)
		value_new.connect("tree_exited", self, "_on_Body_tree_exited")


#func _on_Body_tree_exited()
