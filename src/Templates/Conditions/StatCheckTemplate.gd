extends BaseConditionTemplate
class_name StatCheckTemplate

export (String, "PARTY", "LEADER", "HIGHEST_VALUE", "RANDOM") var type : String = "PARTY"
export (String, "ROLL", "STATIC") var check_type : String = "ROLL"
export (String) var stat_name : String = ""
export (int, 0, 999) var difficulty_check : int = 0




func _init() -> void:
	_instructions = load("res://src/Global/Parser/Instructions/StatCheckInstructions.gd")
