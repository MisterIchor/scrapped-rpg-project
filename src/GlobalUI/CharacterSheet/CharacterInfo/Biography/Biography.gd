extends PanelContainer
signal biography_edit_button_pressed


onready var edit_button: Button = $VBoxBiography/BiographyLabel/EditButton
onready var scroll_container: ScrollContainer = $VBoxBiography/ScrollContainer
onready var display_biography_label: Label = $VBoxBiography/ScrollContainer/DisplayBiographyLabel



func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_focus", [true])
	connect("mouse_exited", self, "_on_mouse_focus", [false])
	edit_button.connect("mouse_entered", self, "_on_EditButton_mouse_focus", [true])
	edit_button.connect("mouse_exited", self, "_on_EditButton_mouse_focus", [false])
	edit_button.connect("pressed", self, "_on_EditButton_pressed")



func _on_mouse_focus(entered : bool) -> void:
	edit_button.visible = entered


func _on_EditButton_pressed() -> void:
	emit_signal("biography_edit_button_pressed")


func _on_EditButton_mouse_focus(entered : bool) -> void:
	edit_button.self_modulate.a = 1.0 if entered else 0.25
