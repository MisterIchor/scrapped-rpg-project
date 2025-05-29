extends Instruction

var target : Soul = null



func _init() -> void:
	add_type("roll_skill", {
		target = "",
		skill_name = "",
		advantage = 0,
	})
	
	add_type("deal_damage", {
		target = "",
		damage_amount = 0,
		damage_type = null,
	})


func _perform_instruction(instruction : Dictionary, _output):
	match instruction.type:
		"roll_skill":
			return



func get_target() -> Array:
	
