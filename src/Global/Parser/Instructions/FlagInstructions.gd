extends Instruction



func _init() -> void:
	set_name("FlagInstructions")



func check(instructions : Dictionary) -> bool:
	match instructions.scope:
		"LOCAL":
			if not ModeSetter.get_current_mode() == "encounter":
				return false
			
			var encounter : Node = ModeSetter.get_current_mode_scene()
			return instructions.flag_name in encounter.local_flags
		"GLOBAL", _:
			var encounter_flags : Array = StorySystem.get_flags_from_encounter(instructions.global_encounter)
			return instructions.flag_name in encounter_flags


func check_and_add(instructions : Dictionary) -> bool:
	if not check(instructions):
		add(instructions)
		return false
	
	return true


func add(instructions : Dictionary) -> bool:
	match instructions.scope:
		"LOCAL":
			if not ModeSetter.get_current_mode() == "encounter":
				return false
			
			var encounter : Node = ModeSetter.get_current_mode_scene()
			encounter.local_flags.append(instructions.flag_name)
			return true
		"GLOBAL", _:
			StorySystem.add_global_flag(instructions.global_encounter, instructions.flag_name)
			return true
