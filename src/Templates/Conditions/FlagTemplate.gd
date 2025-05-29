extends BaseConditionTemplate
class_name FlagTemplate

export (String, "CHECK", "ADD", "CHECK_AND_ADD") var type : String = "CHECK"
export (String, "LOCAL", "GLOBAL") var scope : String = "LOCAL"
export (Resource) var global_encounter : Resource = null
export (String) var flag_name : String = ""
#export (String, "NONE", "DISABLE") var action_if_exists : String = "NONE"



func _init() -> void:
	_instructions = load("res://src/Global/Parser/Instructions/FlagInstructions.gd")
