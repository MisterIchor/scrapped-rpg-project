tool
extends EnhancedObject
class_name Parser

var instructions : Instruction = null setget set_instructions

var _output
var _memory : Dictionary = {}
var _data_to_process : Array = []

signal request_sent(instruction)
signal request_finished(value)



func _init(owner : Object, output_start, instruction = null) -> void:
	set_name("Parser")
	set_owner(owner)
	_output = output_start
	set_instructions(instruction)


func _notification(what: int) -> void:
	if what == NOTIFICATION_OWNER_SET:
		connect_signal_to_owner("request_sent", "_on_Parser_request_sent")
		connect_signal_from_owner("request_finished", "_on_request_finished")
	elif what == NOTIFICATION_OWNER_REMOVED:
		disconnect_signal_to_owner("request_sent", "_on_Parser_request_sent")
		disconnect_signal_from_owner("request_finished", "_on_request_finished")



func add_data(data : Dictionary) -> void:
	_data_to_process.append(data)


func clear_data() -> void:
	_data_to_process.clear()


func clear_memory() -> void:
	_memory.clear()


func perform_instructions() -> void:
	if _output == null:
		LogSystem.write_to_debug("Parser: _output is null. Give it a value before performing instructions.", 0)
		return
	
	for i in _data_to_process:
		instructions._perform_instruction(i, _output)



func set_instructions(new_instructions : Instruction) -> void:
	if instructions:
		instructions.free()
	
	instructions = new_instructions
	
	if instructions:
		instructions.set_owner(self)


func set_output(new_value) -> void:
	_output = new_value



func get_output():
	return _output



func _on_request_finished(value) -> void:
	emit_signal("request_finished", value)


func _on_Instructions_finished(new_output) -> void:
	_output = new_output


func _on_Instructions_request_sent(instruction : Dictionary) -> void:
	emit_signal("request_sent", instruction)


func _on_Instructions_sent_to_memory(value_name : String, value, replace_existing : bool) -> void:
	if _memory.get(value_name):
		if replace_existing:
			_memory[value_name] = value
	elif not _memory.get(value_name):
		_memory[value_name] = value


func _on_Instructions_request_memory_sent(value_name : String) -> void:
	emit_signal("request_finished", _memory.get(value_name))
