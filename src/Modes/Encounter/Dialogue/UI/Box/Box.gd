extends "../DialogueUIBase.gd"



func _enter_tree() -> void:
	dialogue_box = $ColorRect/VBoxContainer/DialogueBox
	choice_box = $ColorRect/VBoxContainer/AnswerBox
