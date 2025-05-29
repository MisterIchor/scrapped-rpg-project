tool
extends CalculatedAttributeTemplate
class_name SkillTemplate

export (Dictionary) var unlockable_abilities



func _init() -> void:
	base = 0



func _set(property: String, value) -> bool:
	if property == "base":
		return false
	
	return true
