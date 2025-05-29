extends Instruction



func _init() -> void:
	set_name("CharacterInfoInstructions")



func double(instruction : Dictionary, _output) -> String:
	var first_type : int = typeof(instruction.first_value)
	var second_type : int = typeof(instruction.second_value)
	
	if first_type == TYPE_INT or first_type == TYPE_REAL:
		if second_type == TYPE_INT or second_type == TYPE_REAL:
			return str(instruction.first_value, "/", instruction.second_value)
	
	return str(instruction.first_value, " ", instruction.second_value)
