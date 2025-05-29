extends VBoxContainer

onready var oldcharchkbox : CheckBox = ($PreMadeCharCheckbox as BaseButton)
onready var newcharchkbox : CheckBox = ($NewCharCheckbox as BaseButton)



func _on_NewCharCheckbox_toggled(button_pressed):
	if oldcharchkbox.is_pressed():
		oldcharchkbox.pressed = !oldcharchkbox.pressed

func _on_PreMadeCharCheckbox_toggled(button_pressed):
	if newcharchkbox.is_pressed():
		newcharchkbox.pressed = !newcharchkbox.pressed
