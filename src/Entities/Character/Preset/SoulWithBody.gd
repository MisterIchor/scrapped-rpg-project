extends Soul

func _init() -> void:
	add_data_container("actions", preload("res://src/Entities/Character/Containers/Actions.gd"))
	add_data_container("personal_info")
	add_data_container("inventory")
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/strength.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/enderance.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/dexterity.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/agility.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/intelligence.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/wisdom.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/perception.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/charisma.tres"))
	add_attribute(load("res://src/Resources/Soul/Stats/Attributes/luck.tres"))
	add_stat(load("res://src/Resources/Soul/Stats/Base/health.tres"))
	add_stat(load("res://src/Resources/Soul/Stats/Base/stamina.tres"))
	add_skill(load("res://src/Resources/Soul/Stats/Skills/cooking.tres"))
	add_skill(load("res://src/Resources/Soul/Stats/Skills/brewery.tres"))
	add_skill(load("res://src/Resources/Soul/Stats/Skills/divinity.tres"))
	add_skill(load("res://src/Resources/Soul/Stats/Skills/nature.tres"))
	add_skill(load("res://src/Resources/Soul/Stats/Skills/surgery.tres"))
	add_skill(load("res://src/Resources/Soul/Stats/Skills/first_aid.tres"))



func add_action(template : ActionTemplate) -> ActionTemplate:
	get_container("actions").add_value(template.name, template)
	return template


func add_personal_info(info_name : String, info : String) -> void:
	get_container("personal_info").add_value(info_name, info)
