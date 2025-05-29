extends Object
class_name EnhancedObject

const NOTIFICATION_OWNER_REMOVED : int = 3
const NOTIFICATION_OWNER_SET : int = 4
const messages : Dictionary = {
	connect_start = ["connecting signal %s to function %s of target %s...", 3],
	connect_success = ["signal connected successfully!", 3],
	connect_failed = ["failed to connect signal, returned %s.", 0],
	disconnect_start = ["disconnecting signal %s from function %s of target %s...", 3],
	disconnect_success = ["signal disconnected successfully!", 3],
	already_connected = ["signal is already connected.", 3],
	not_connected = ["signal is not connected.", 3],
	no_owner_found = ["owner is null, returning.", 3],
	no_signal_found = ["signal %s could not be found on %s.", 0],
	no_function_found = ["function %s could not be found on target %s.", 0],
	no_target_found = ["target is null, returning.", 3],
	message_less_placeholders = ["there aren't enough placeholders for message %s.", 3],
}

var name : String = "EnhancedObject" setget set_name
var owner : Object = null setget set_owner, get_owner

signal name_changed(new_name)
signal tree_exiting
signal owner_set



func _init() -> void:
	if get_script():
		set_name(get_script_name())


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			emit_signal("tree_exiting")
		NOTIFICATION_OWNER_REMOVED:
			disconnect_signal_from_owner("tree_exiting", "_on_Owner_tree_exiting")
		NOTIFICATION_OWNER_SET:
			connect_signal_from_owner("tree_exiting", "_on_Owner_tree_exiting")


func _to_string() -> String:
	return str("[", get_script_name(), ":", get_instance_id(), "]")



func _pre_connection_check(signal_name : String, function_name : String) -> bool:
	if not get_owner():
		log_debug(messages.no_owner_found)
		return false
	
	return true


func _pre_connection_to_owner_check(signal_name : String, function_name : String) -> bool:
	if not _pre_connection_check(signal_name, function_name):
		return false
	
	if not has_signal(signal_name):
		log_debug(messages.no_signal_found, [signal_name, name])
		return false
	
	if not owner.has_method(function_name):
		log_debug(messages.no_function_found, [function_name, get_target_name(owner)])
		return false
	
	return true


func _pre_connection_from_owner_check(signal_name : String, function_name : String) -> bool:
	if not _pre_connection_check(signal_name, function_name):
		return false
	
	if not owner.has_signal(signal_name):
		log_debug(messages.no_signal_found, [signal_name, get_target_name(owner)])
		return false
	
	if not has_method(function_name):
		log_debug(messages.no_function_found, [function_name, get_target_name(self)])
		return false
	
	return true



func connect(signal_name : String, target : Object, function : String, binds : Array = [], flags : int = 0) -> int:
	log_debug(messages.connect_start, [signal_name, function, get_target_name(target)])
	
	if is_connected(signal_name, target, function):
		log_debug(messages.already_connected)
		return OK
	
	var status : int = .connect(signal_name, target, function, binds, flags)
	
	if not status == OK:
		log_debug(messages.connect_failed, [status])
		return status
	
	log_debug(messages.connect_success)
	return status


func disconnect(signal_name : String, target : Object, function : String) -> void:
	log_debug(messages.disconnect_start, [signal_name, function, get_target_name(target)])
	
	if not is_connected(signal_name, target, function):
		log_debug(messages.not_connected)
		return
	
	.disconnect(signal_name, target, function)
	log_debug(messages.disconnect_success)


func connect_signal_to_owner(signal_name : String, function_name : String, binds : Array = [], flags : int = 0) -> int:
	if not _pre_connection_to_owner_check(signal_name, function_name):
		return FAILED
	
	return connect(signal_name, owner, function_name, binds, flags)


func connect_signal_from_owner(signal_name : String, function_name : String, binds : Array = [], flags : int = 0) -> int:
	if not _pre_connection_from_owner_check(signal_name, function_name):
		return FAILED
	
	return owner.connect(signal_name, self, function_name, binds, flags)


func disconnect_signal_to_owner(signal_name : String, function_name : String) -> void:
	if not _pre_connection_check(signal_name, function_name):
		return
	
	disconnect(signal_name, owner, function_name)


func disconnect_signal_from_owner(signal_name : String, function_name : String) -> void:
	if not _pre_connection_check(signal_name, function_name):
		return
	
	owner.disconnect(signal_name, self, function_name)


func log_debug(message_to_log : Array, placeholders : Array = []) -> void:
	var new_message : String = message_to_log[0].insert(0, str(name, ": "))
	
	if placeholders.size() >= 1:
		if message_to_log[0].count("%s") < placeholders.size():
			log_debug(messages.message_less_placeholders, [message_to_log])
			return
		
		new_message = new_message % placeholders
	
	LogSystem.write_to_debug(new_message, message_to_log[1])



func set_name(new_name : String) -> void:
	name = new_name
	emit_signal("name_changed", new_name)


func set_owner(new_owner : Object) -> void:
	if owner:
		notification(NOTIFICATION_OWNER_REMOVED, true)
	
	owner = new_owner
	
	if owner:
		notification(NOTIFICATION_OWNER_SET, true)
		emit_signal("owner_set")



func get_class() -> String:
	return get_script().resource_path.get_file().get_basename()


func get_script_property_list() -> Array:
	return get_script().get_script_property_list()


func get_script_name() -> String:
	return get_script().resource_path.get_file().get_basename()


func get_target_name(target : Object) -> String:
	if not target == null:
		return target.name if target.get("name") else target.get_class()
	
	return "null"


func get_owner() -> Object:
	return owner



func _on_Owner_tree_exiting() -> void:
	call_deferred("free")
