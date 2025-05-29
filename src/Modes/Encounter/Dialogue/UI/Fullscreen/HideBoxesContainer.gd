extends HBoxContainer

onready var label : Label = ($Label as Label)
onready var button : Button = ($Button as Button)



func _ready() -> void:
	button.connect("mouse_entered", self, "_on_Button_mouse_entered")
	button.connect("mouse_exited", self, "_on_Button_mouse_exited")
	button.connect("toggled", self, "_on_Button_toggled")
	label.hide()



func _on_Button_mouse_entered() -> void:
	label.show()


func _on_Button_mouse_exited() -> void:
	label.hide()


func _on_Button_toggled(is_toggled : bool) -> void:
	label.set_text("Show boxes" if is_toggled else "Hide boxes")
