extends "../Instruction.gd"



func _init() -> void:
	add_type("percentage_check", {
		comparison_to_use = "",
		container_name = "",
		value_name = "",
		percentage = "",
	})
	
	add_type("value_check", {
		comparison_to_use = "",
		container_name = "",
		value_name = "",
		value = "",
	})
	
	add_type("environment_check", {
		is_environment = "",
	})



func _perform_instruction(instruction : Dictionary, output) -> void:
	._perform_instruction(instruction, output)
	
	match instruction.type:
		"percentage_check":
			var value : int = perform_request([instruction.container_name, instruction.value_name])
			var value_max : int = perform_request([instruction.container_name, "value_max"])
			
			if not value or not value_max:
				LogSystem.write_to_debug("Parser: value or max value not found.")
				return
			
			output = value / value_max
			
			if make_comparison(instruction.comparison_to_use, output, instruction.percentage):
				pass


