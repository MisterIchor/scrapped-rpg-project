tool
extends Resource
class_name AnswerTemplate

export (String, MULTILINE) var dialogue : String = String()
export (Resource) var go_to : Resource
export (bool) var end_dialogue : bool = false
export (String, "WORLD", "BATTLE") var end_type : String

# If conditions are met, dialogue_to_add will be appended to dialogue.
var InitSettings : Dictionary = {
	conditions = [],
	dialogue_to_add = "",
}
# Conditions and dialogue_success are only used in the editor.
var BranchSettings : Dictionary = {
	conditions = [],
	dialogue_success = null,
	branches = {},
}



func _init() -> void:
	if not Engine.editor_hint:
		BranchSettings.erase("conditions")
		BranchSettings.erase("dialogue_success")



func _get_property_list() -> Array:
	var property_list : Array = []
	
	if Engine.editor_hint:
		return property_list
	
	property_list.append({
		name = "InitizationSettings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP,
		hint_string = "ins_"
	})
	
	property_list.append({
		name = "ins_conditions",
		type = TYPE_ARRAY,
	})
	
	property_list.append({
		name = "ins_dialogue_to_add",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_MULTILINE_TEXT
	})
	
	
	property_list.append({
		name = "BranchSettings",
		type = TYPE_NIL,
		hint_string = "br_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "br_branches",
		type = TYPE_DICTIONARY
	})
	
	property_list.append({
		name = "br_conditions",
		type = TYPE_ARRAY,
	})
	
	property_list.append({
		name = "br_dialogue_if_successful",
		type = TYPE_OBJECT
	})
	
	property_list.append({
		name = "br_add_branch",
		type = TYPE_BOOL,
	})
	
	return property_list


func _set(property: String, value) -> bool:
	match property:
		"ins_conditions":
			if Engine.editor_hint:
				for i in range(value.size()):
					if not value[i]:
						value[i] = Resource.new()
					elif value[i] is GDScript:
						var template : Resource = Resource.new()
						
						template.set_script(value[i])
						value[i] = template
			
			InitSettings.conditions = value
		
		"ins_dialogue_to_add":
			InitSettings.dialogue_to_add = value
		
		"br_conditions":
			if Engine.editor_hint:
				for i in range(value.size()):
					if not value[i]:
						value[i] = Resource.new()
					elif value[i] is GDScript:
							var template : Resource = Resource.new()
							
							template.set_script(value[i])
							value[i] = template
			
			BranchSettings.conditions = value
		
		"br_branches":
			BranchSettings.branches = value
		
		"br_dialogue_if_successful":
			BranchSettings.dialogue_success = value
		
		"br_add_branch":
			if value:
				BranchSettings.branches[BranchSettings.conditions] = BranchSettings.dialogue_success
	
	return true


func _get(property: String):
	match property:
		"ins_conditions":
			return InitSettings.conditions
		
		"ins_dialogue_to_add":
			return InitSettings.dialogue_to_add
		
		"br_branches":
			return BranchSettings.branches
		
		"br_conditions":
			return BranchSettings.conditions
		 
		"br_dialogue_if_successful":
			return BranchSettings.dialogue_success
