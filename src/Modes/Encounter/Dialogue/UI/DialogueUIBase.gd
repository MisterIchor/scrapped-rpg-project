extends Control

var dialogue_box : Control = null
var choice_box : Control = null



func set_dialogue(new_dialogue : String) -> void:
	dialogue_box.set_dialogue(new_dialogue)


func set_answers(new_answers : Array) -> void:
	choice_box.clear_answers()
	
	var index : int = 0
	
	for i in new_answers:
		var dialogue : String = i.dialogue
		
#		if not skill_check.skill_name.empty():
#			dialogue = dialogue.insert(0, "[" + skill_check.skill_name.capitalize() + "] ")
		
		choice_box.add_choice(dialogue, index)
		index += 1
