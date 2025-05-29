extends DisplayTemplate
class_name ModifierTemplate

export (Resource) var type : Resource
export (GDScript) var modifier_instructions : GDScript = null
export (Dictionary) var input : Dictionary = {}
# -1 means it will last forever or until removed.
export (float) var seconds : float = -1

var _parser : Parser = Parser.new(self, 0)



func run_parser() -> void:
	_parser.perform_instructions()


func get_modifier_output():
	return _parser.get_output()
