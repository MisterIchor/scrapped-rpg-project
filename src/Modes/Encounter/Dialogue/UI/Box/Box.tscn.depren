extends ColorRect

const DialogueButton : PackedScene = preload("res://src/Modes/Encounter/Dialogue/UI/DialogueButton.tscn")

onready var box : VBoxContainer = ($ScrollContainer/VBoxContainer as VBoxContainer)

var flat_buttons : bool = false setget set_flat_buttons

signal dialogue_selected(index)



func add_choice(dialogue : String, index : int) -> void:
	var dialogue_button : Button = DialogueButton.instance()
	
	dialogue_button.set_text(dialogue)
	dialogue_button.set_flat(flat_buttons)
	dialogue_button.connect("pressed", self, "_on_DialogueButton_pressed", [index])
	box.add_child(dialogue_button)
	box.move_child(dialogue_button, index)


func clear_answers() -> void:
	for i in box.get_children():
		i.queue_free()



func set_answers_box_transparency(percentage : int) -> void:
	set_self_modulate(Color(1, 1, 1, percentage * 0.01))


func set_flat_buttons(value : bool) -> void:
	flat_buttons = value
	
	for i in box.get_children():
		i.set_self_modulate(Color(0, 0, 0, 0.1))



func _on_DialogueButton_pressed(index : int) -> void:
	emit_signal("dialogue_selected", index)
