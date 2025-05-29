tool
extends HBoxContainer

export (String) var skill : String = String() setget set_skill
signal skill_selected(name_of_skill)



func set_skill(new_skill : String) -> void:
	skill = new_skill
	if Engine.editor_hint:
		($Name as Label).text = skill
	emit_signal("skill_selected")
