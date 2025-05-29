extends "../DialogueUIBase.gd"

onready var portrait : TextureRect = ($DialogueBox/DialogueContainer/PortraitBackground as TextureRect)
onready var hide_boxes : HBoxContainer = ($HideBoxesContainer as HBoxContainer)



func _enter_tree() -> void:
	dialogue_box = $DialogueBox
	choice_box = $Choices


func _ready() -> void:
	if portrait.is_visible():
		portrait.hide()
	
	dialogue_box.set_portrait_visible(false)
	dialogue_box.set_dialogue_background_transparency(20)
	choice_box.set_answers_box_transparency(20)
	choice_box.set_flat_buttons(true)
	hide_boxes.button.connect("toggled", self, "_on_Button_toggled")



func _on_Button_toggled(is_toggled : bool) -> void:
	dialogue_box.set_visible(!is_toggled)
	choice_box.set_visible(!is_toggled)
