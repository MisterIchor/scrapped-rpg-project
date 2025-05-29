extends Instruction



func _init() -> void:
	set_name("CalculateStatInstructions")



func arithmetic(instruction : Dictionary, output : int) -> int:
	var value : int = int(instruction.value)
	
	match instruction.operation:
		"add":
			output += value
		"subtract":
			output -= value
		"divide":
			if value == 0 or instruction.value == 0:
				log_debug(["attempted to divide or divide by 0.", 0])
				continue
			
			output /= value
		"multiply":
			output *= value
	
	return output


func arithmetic_with_stat(instruction : Dictionary, output : int) -> int:
	var stat : int = get_stat(instruction)
	
	if stat == 0:
		return output
	
	instruction.value = stat
	return arithmetic(instruction, output)


func get_stat(instruction : Dictionary) -> int:
	var value_foreign = perform_request(instruction)
	var percentage : float = int(instruction.percentage_of_value) * 0.01
	
	if not value_foreign:
		return 0
	
	value_foreign *= percentage
	return value_foreign
