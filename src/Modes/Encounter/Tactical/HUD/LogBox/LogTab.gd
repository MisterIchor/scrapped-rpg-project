extends ScrollContainer



func _enter_tree() -> void:
	LogSystem.connect("log_written", self, "_on_LogSystem_log_written")



func _on_LogSystem_log_written(catagory_name : String, text : String, time : String) -> void:
	if catagory_name.matchn(name) or name.matchn("all"):
		$Background/Label.text += time + " " + text + "\n"
