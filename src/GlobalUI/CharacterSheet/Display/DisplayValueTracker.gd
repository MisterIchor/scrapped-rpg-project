extends "DisplayContainerValue.gd"

signal show_details(value_tracker)

onready var details_button : Button = ($DetailsButton as Button)



func _ready() -> void:
	details_button.connect("mouse_entered", self, "_on_DetailsButton_mouse_focus", [true])
	details_button.connect("mouse_exited", self, "_on_DetailsButton_mouse_focus", [false])
	details_button.connect("pressed", self, "_on_DetailsButton_pressed")


func set_container(new_container : DataContainer) -> void:
	if not new_container is ValueTracker:
		return
	
	.set_container(new_container)



func _on_DetailsButton_mouse_focus(has_mouse_focus : bool) -> void:
	details_button.self_modulate.a = 0.25 if has_mouse_focus else 0.0


func _on_DetailsButton_pressed() -> void:
	emit_signal("show_details", container)
