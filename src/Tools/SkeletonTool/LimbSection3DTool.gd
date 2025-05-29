tool
extends LimbSection3D

var section_template : LimbSectionTemplate = load("res://src/Resources/Skeleton/DefaultLimbSections/DefaultLimbSection.tres").duplicate(true)



func _update_section() -> void:
	if section_template:
		self.name = section_template.name
		set("length_size", section_template.length)
		set("reset_front_translation", true)
		set_mesh(section_template.mesh)



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "connected_to_section",
		type = TYPE_NODE_PATH
	})
	
	property_list.append({
		name = "reset_front_translation",
		type = TYPE_BOOL
	})
	
	property_list.append({
		name = "Template Settings",
		type = TYPE_NIL,
		hint_string = "ts_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "ts_update_section",
		type = TYPE_BOOL
	})
	
	property_list.append({
		name = "ts_template",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "LimbSectionTemplate"
	})
	
	return property_list



func _set(property: String, value) -> bool:
	if property == "reset_front_translation":
		if value == true:
			front.translation = Vector3(get_length_3d(), 0, 0)
		
		return true
	
	if property == "ts_template":
		section_template = value
		return true
	
	if property == "ts_update_section":
		_update_section()
		return true
	
	return false


func _get(property : String):
	if property == "ts_template":
		return section_template
