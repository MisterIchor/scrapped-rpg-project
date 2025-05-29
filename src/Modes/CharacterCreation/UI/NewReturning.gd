extends PanelContainer

onready var new_box : CheckBox = ($VBoxContainer/NewBox as CheckBox)
onready var returning_box : CheckBox = ($VBoxContainer/ReturningBox as CheckBox)



func _ready() -> void:
	new_box.connect("toggled", self, "_on_CheckBox_checked", ["new_box"])
	returning_box.connect("toggled", self, "_on_CheckBox_checked", ["returning_box"])



func _on_CheckBox_checked(button_pressed : bool, box : String) -> void:
	if button_pressed:
		match box:
			"new_box":
				if returning_box.pressed:
					returning_box.pressed = false
			"returning_box":
				if new_box.pressed:
					new_box.pressed = false
