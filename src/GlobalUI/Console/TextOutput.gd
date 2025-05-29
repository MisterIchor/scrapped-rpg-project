extends RichTextLabel



func _ready() -> void:
	LogSystem.connect("log_written", self, "_on_LogSystem_log_written")
	ConsoleSystem.add_to_console(self)



func add_text(text : String) -> void:
	.add_text(text)
	newline()


func clear_console() -> void:
	clear()



func _on_LogSystem_log_written(catagory_name : String, text : String, time : String) -> void:
	if catagory_name == "debug":
		add_text(str(time, " ", text))
