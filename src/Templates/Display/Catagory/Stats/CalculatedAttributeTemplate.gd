tool
extends AttributeTemplate
class_name CalculatedAttributeTemplate

enum FormulaTypes {SELECT_TYPE, ARITHMETIC, ARITHMETIC_WITH_STAT}

export (Array, Dictionary) var formula : Array = Array() setget set_formula
export (FormulaTypes) var _add_type setget _add_type



func _add_type(type : int) -> void:
	if type == FormulaTypes.SELECT_TYPE:
		return
	
	var instruction : Dictionary = {}
	
	match type:
		FormulaTypes.SELECT_TYPE:
			return
		FormulaTypes.ARITHMETIC:
			instruction.type = "arithmetic"
			instruction.operation = ""
			instruction.value = 0
		FormulaTypes.ARITHMETIC_WITH_STAT:
			instruction.type = "arithmetic_with_stat"
			instruction.operation = ""
			instruction.container_name = ""
			instruction.value_name = ""
			instruction.percentage_of_value = 0
	
	var formula_new : Array = formula.duplicate(true)
	
	formula_new.append(instruction)
	set_formula(formula_new)
	_add_type(FormulaTypes.SELECT_TYPE)
	property_list_changed_notify()


func set_formula(value : Array) -> void:
	formula = value
