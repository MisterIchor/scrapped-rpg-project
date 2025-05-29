extends DataContainer
class_name TemplateContainer

const NOTIFICATION_TEMPLATE_REMOVED : int = 6
const NOTIFICATION_TEMPLATE_SET : int = 7

var template : BaseTemplate setget set_template, get_template
var _parser : Parser = null

signal template_set
signal value_requested(requester, container_requested)
signal request_finished(value)



func _init() -> void:
	messages.template_not_resource = ["Resource provided is not a template.", 0]
	messages.no_parser_found = ["Could not find parser.", 0]
	set_name("TemplateContainer")


func _notification(what: int) -> void:
	._notification(what)
	
	match what:
		NOTIFICATION_TEMPLATE_SET:
			name = template.name
			emit_signal("template_set")
		NOTIFICATION_GET_DATA:
			_data_to_send.merge({template = template})


func _get(property: String):
	var value = ._get(property)
	
	if value:
		return value
	
	if template:
		return template.get(property)



func add_data_to_parser(data : Dictionary) -> void:
	_parser.add_data(data)


func clear_parser_data() -> void:
	_parser.clear_data()


func enable_parser(value : bool, init_output) -> void:
	if not owner:
		yield(self, "owner_set")
	
	if value:
		connect_signal_to_owner("value_requested", "_on_Container_value_requested")
		connect_signal_from_owner("requested_value_sent", "_on_requested_value_sent")
		
		if not _parser:
			_parser = Parser.new(self, init_output)
	
	if not value:
		disconnect_signal_to_owner("value_requested", "_on_Container_value_requested")
		disconnect_signal_from_owner("requested_value_sent", "_on_requested_value_sent")
		
		if _parser:
			_parser.free()


func run_parser() -> void:
	_parser.perform_instructions()



func set_parser_output(new_value) -> void:
	_parser.set_output(new_value)


func set_parser_instructions(new_instructions : Instruction) -> void:
	if not owner:
		yield(self, "owner_set")
	
	if not _parser:
		log_debug(messages.no_parser_found)
		return
	
	_parser.set_instructions(new_instructions)


func set_template(new_template : BaseTemplate) -> void:
	if not new_template is BaseTemplate:
		log_debug(messages.template_not_resource)
		return
	
	if template:
		notification(NOTIFICATION_TEMPLATE_REMOVED, true)
	
	template = new_template
	
	if template:
		notification(NOTIFICATION_TEMPLATE_SET, true)


func get_template() -> BaseTemplate:
	return template


func get_parser_output():
	return _parser.get_output()



func is_parser_enabled() -> bool:
	return not _parser == null



func _on_requested_value_sent(requester : Object, value) -> void:
	if requester == self:
		emit_signal("request_finished", value)


func _on_Parser_request_sent(instruction : Dictionary) -> void:
	emit_signal("value_requested", self, instruction.container_name, instruction.value_name)
