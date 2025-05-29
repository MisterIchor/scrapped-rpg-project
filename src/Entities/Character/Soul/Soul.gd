extends "../ContainerManager.gd"
class_name Soul

enum Controller {PLAYER, NON_PLAYER}

var preset : Resource setget set_preset
var type : int = Controller.PLAYER setget set_type

signal type_changed(type)



func _init() -> void:
	file_manager.folder_path = "res://assets/saved/souls"
	add_data_container("soul_name", preload("res://src/Entities/Character/Details/Name.gd"))
	add_data_container("appearance", preload("res://src/Entities/Character/Details/Appearance.gd"))
	add_data_container("achievments")
	add_data_container("details")
	add_data_container("traits")
	add_data_container("personality")
	add_data_container("modifiers")



func _set_preset(new_preset) -> void:
	preset = new_preset


func add_attribute(template : AttributeTemplate) -> Attribute:
	return add_template_container(template, load("res://src/Entities/Character/Features/Statistics/Attribute.gd"))


func add_stat(template : CalculatedAttributeTemplate) -> Stat:
	return add_template_container(template, load("res://src/Entities/Character/Features/Statistics/Stat.gd"))


func add_skill(template : SkillTemplate) -> Skill:
	return add_template_container(template, load("res://src/Entities/Character/Features/Statistics/Skill.gd"))


func add_trait(template : TraitTemplate) -> void:
	var traits_container : DataContainer = get_container("traits")
	
	if not traits_container.get(template.name):
		traits_container.add_value(template.name, template)


#func track(stat)



func set_preset(new_preset : Resource) -> void:
	_set_preset(new_preset)


func set_type(new_type : int) -> void:
	type = new_type
	emit_signal("type_changed", Controller.keys()[type])



func _on_Container_value_changed(container_name : String, value_name : String, value, value_old) -> void:
	if container_name == "soul_name" and 	value_name == "full_name":
		set_name(value.replacen(" ", ""))
	
	._on_Container_value_changed(container_name, value_name, value, value_old)
