tool
extends Resource

export (String, MULTILINE) var dialogue : String = String()
export (Resource) var go_to : Resource
export (bool) var end_dialogue : bool = false
export (String, "WORLD", "BATTLE") var end_type : String

var Types : PoolStringArray = ["LOCAL", "GLOBAL"]
var CheckedActions : PoolStringArray = ["NONE", "DISABLE"]
var InitSettings : Dictionary = {
	conditions = [],
	dialogue_to_add = "",
}
var Flag : Dictionary = {
	name = String(),
	type = String(),
	checked_action = String(),
}
var SkillSettings : Dictionary = {
	skill_check = SkillCheckTemplate.new(),
	dialogue_success = null,
}



func get_skill_check() -> SkillCheckTemplate:
	return SkillSettings.get("skill_check")



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "InitizationSettings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP,
		hint_string = "ins_"
	})
	
	property_list.append({
		name = "ins_skill_check_to_appear",
		type = TYPE_OBJECT,
	})
	
	property_list.append({
		name = "ins_dialogue_to_add",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_MULTILINE_TEXT
	})
	
	property_list.append({
		name = "Flag",
		type = TYPE_NIL,
		hint_string = "flag_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "flag_name",
		type = TYPE_STRING,
	})
	
	property_list.append({
		name = "flag_type",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = Types.join(","),
	})
	
	property_list.append({
		name = "flag_action_if_checked",
		type = TYPE_STRING, 
		hint = PROPERTY_HINT_ENUM,
		hint_string = CheckedActions.join(",")
	})
	
	
	property_list.append({
		name = "SkillSettings",
		type = TYPE_NIL,
		hint_string = "sc_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "sc_settings",
		type = TYPE_OBJECT,
	})
	
	property_list.append({
		name = "sc_dialogue_if_successful",
		type = TYPE_OBJECT
	})
	
	return property_list


func _set(property: String, value) -> bool:
	match property:
		"ins_skill_check_to_appear":
			InitSettings.skill_check_to_appear = value
		
		"ins_dialogue_to_add":
			InitSettings.dialogue_to_add = value
		
		"flag_name":
			Flag.name = value
		
		"flag_type":
			Flag.type = value
		
		"flag_action_if_checked":
			Flag.checked_action = value
		
		"sc_settings":
			SkillSettings.skill_check = value
		
		"sc_dialogue_if_successful":
			SkillSettings.dialogue_success = value
	
	return true


func _get(property: String):
	match property:
		"ins_skill_check_to_appear":
			return InitSettings.skill_check_to_appear
		
		"ins_dialogue_to_add":
			return InitSettings.dialogue_to_add
		
		"flag_name":
			return Flag.name
		
		"flag_type":
			return Flag.type
		
		"flag_action_if_checked":
			return Flag.checked_action
		
		"sc_settings":
			return SkillSettings.skill_check
		 
		"sc_dialogue_if_successful":
			return SkillSettings.dialogue_success
