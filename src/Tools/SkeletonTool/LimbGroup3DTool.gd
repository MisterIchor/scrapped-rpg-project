tool
extends LimbGroup3D

var section_templates : Array = []
var limb_name : String = ""



func _set(property: String, value) -> bool:
	match property:
		"ls_add_limb":
			if value:
				var new_limb : Limb3D = add_limb(limb_name, section_templates)
				
				new_limb.set_script(load("res://src/Tools/SkeletonTool/Limb3DTool.gd"))
				new_limb.owner = get_tree().edited_scene_root
				return true
		"ls_limb_name":
			limb_name = value
			return true
		"ls_section_templates":
			section_templates = value
			
			for i in section_templates.size():
				if not section_templates[i]:
					section_templates[i] = Resource.new()

	return false


func _get(property: String):
	match property:
		"ls_limb_name":
			return limb_name
		"ls_section_templates":
			return section_templates


func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "side",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Right or not applicable:1,Left:-1"
	})
	
	property_list.append({
		name = "Limb Settings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint_string = "ls_"
	})
	
	property_list.append({
		name = "ls_limb_name",
		type = TYPE_STRING,
	})
	
	property_list.append({
		name = "ls_section_templates",
		type = TYPE_ARRAY,
	})
	
	property_list.append({
		name = "ls_add_limb",
		type = TYPE_BOOL
	})
	return property_list
