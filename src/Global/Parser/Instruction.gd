extends EnhancedObject
class_name Instruction

var value_requested

signal request_sent(instruction)
signal finished(new_output)
signal request_memory_sent(value_name)
signal sent_to_memory(value_name, value)



func _init() -> void:
	set_name("Instruction")
	messages.no_method_found = ["Could not find method %s", 0]


func _notification(what: int) -> void:
	if what == NOTIFICATION_OWNER_SET:
		connect_signal_to_owner("finished", "_on_Instructions_finished")
		connect_signal_to_owner("request_sent", "_on_Instructions_request_sent")
		connect_signal_to_owner("sent_to_memory" ,"_on_Instructions_sent_to_memory")
		connect_signal_from_owner("request_finished", "_on_request_finished")
		connect_signal_to_owner("request_memory_sent", "_on_Instructions_request_memory_sent")
	elif what == NOTIFICATION_OWNER_REMOVED:
		disconnect_signal_to_owner("finished", "_on_Instructions_finished")
		disconnect_signal_to_owner("request_sent", "_on_Instructions_request_sent")
		disconnect_signal_to_owner("sent_to_memory" ,"_on_Instructions_sent_to_memory")
		disconnect_signal_from_owner("request_finished", "_on_request_finished")
		disconnect_signal_to_owner("request_memory_sent", "_on_Instructions_request_memory_sent")



func _perform_instruction(instruction : Dictionary, output) -> void:
	if not instruction.get("type"):
		return
	
	var type : String = instruction.type
	type = type.to_lower()
	type = type.replace(" ", "_")
	
	if not has_method(type):
		log_debug(messages.no_method_found, [instruction.type])
		return
	
	output = call(type, instruction, output)
	emit_signal("finished", output)



func perform_request(instruction : Dictionary):
	emit_signal("request_sent", instruction)
	return value_requested



func _on_request_finished(value) -> void:
	value_requested = value
