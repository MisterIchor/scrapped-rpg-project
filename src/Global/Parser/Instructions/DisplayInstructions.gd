extends Instruction



func exception(instruction : Dictionary, output) -> Dictionary:
	output.erase(instruction.property_name)
	return output
