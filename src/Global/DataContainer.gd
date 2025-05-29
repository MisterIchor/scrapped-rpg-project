extends EnhancedObject
class_name DataContainer

const NOTIFICATION_GET_DATA : int = 5

# Everything in data will be saved when ContainerManager.save_to_file() is called.
var data : Dictionary = {}
# When get_data() is called, all the data that is collected by NOTIFICATION_GET_DATA
# is stored here. Once the data is sent, this will be replace with an empty dictionary.
var _data_to_send : Dictionary = {}
# Affects whether it accepts "value_changed" signals from other DataContainers.
# Does not prevent itself from emitting the signal.
var _process_changed_values : bool = false setget set_process_changed_values

signal value_changed(container, value_name, value_new, value_old)
signal _data_collected(new_data)


func _init() -> void:
	messages.type_mismatch = ["value %s is not the same type as value %s. (%s)", 0]
	messages.no_value_found = ["value %s does not exists. Check for typos.", 0]
	messages.value_is_property = ["value %s already exists as a property.", 0]
	messages.value_exists = ["value %s already exists.", 0]
	messages.value_overrided = ["value %s overided with value of %s.", 0]
	messages.signal_exists = ["signal %s already exists.", 0]
	messages.signal_added = ["signal %s added.", 2]
	connect("_data_collected", self, "__on_data_collected")
	set_name("DataContainer")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_OWNER_REMOVED:
			disconnect_signal_to_owner("value_changed", "_on_Container_value_changed")
		NOTIFICATION_OWNER_SET:
			connect_signal_to_owner("value_changed", "_on_Container_value_changed")
		NOTIFICATION_GET_DATA:
			_data_to_send.merge(data)


func _set(property: String, value) -> bool:
	var value_set : bool = false
	var value_old = get(property)
	
	if data.has(property):
		if not is_same_type(property, value):
			log_debug(messages.type_mismatch, [value, get(property), property])
		elif not value_old == value:
			data[property] = value
			value_set = true
	else:
		if not value == value_old:
			value_set = true
	
	if value_set:
		emit_signal("value_changed", name.to_lower(), property, value, value_old)
	
	return value_set


func _get(property: String):
	if data.has(property):
		return data.get(property)



func add_value(value_name : String, initial_value) -> void:
	if get_value_type(value_name) == "property":
#		log_debug(messages.value_is_property, [value_name])
		return
	
	if not get_value_type(value_name) == String():
		log_debug(messages.value_exists, [value_name])
		return
	
	data[value_name] = initial_value


func append_to_array(array_name : String, value, merge_if_array : bool = false) -> void:
	var array : Array = get(array_name)
	
	if typeof(value) > 18 and typeof(value) < 27:
		array.append_array(value) if merge_if_array else array.append(value)
	else:
		array.append(value)
	
	emit_signal("value_changed", array_name, value, value)


func increment_value(value_name : String, by : float) -> void:
	if not data.has(value_name):
		return
	
	var current_value : float = get(value_name)
	set(value_name, current_value + by)


func remove_value_in_array(array_name : String, index : int) -> void:
	var array : Array = get(array_name)
	array.remove(index)
	emit_signal("value_changed", array_name, array, array)


func override_value(value_name : String, value) -> void:
	if not is_same_type(value_name, value):
		log_debug(messages.value_overrided, [value_name, value])
	
	data[value_name] = value



func set_key_in_dictionary(dict_name : String, key, value) -> void:
	var dict : Dictionary = get(dict_name)
	
	if not dict.has(key):
		dict[key] = value
		emit_signal("value_changed", dict_name, value, value)


func override_key_in_dictionary(dict_name : String, key : String, value) -> void:
	var dict : Dictionary = get(dict_name)
	dict[key] = value


func remove_key_in_dictionary(dict_name : String, key : String) -> void:
	get(dict_name).erase(key)


func set_value_in_array(array_name : String, index : int, value) -> void:
	var array : Array = get(array_name)
	
	if index > array.size() - 1:
		return
	
	if value == null:
		array.remove(index)
	else:
		array[index] = value
	
	emit_signal("value_changed", array_name, array, array)


func set_clamped(property : String, value : float, minimum : float, maximum : float) -> void:
	set(property, clamp(value, minimum, maximum))


func set_process_changed_values(value : bool) -> void:
	_process_changed_values = value
	
	if not owner:
		yield(self, "owner_set")
	
	if not _process_changed_values:
		disconnect_signal_from_owner("changed_value_sent", "_on_changed_value_sent")
	else:
		connect_signal_from_owner("changed_value_sent", "_on_changed_value_sent")



func has_value(value_name : String) -> bool:
	return data.has(value_name)



func get_value_type(value_name : String) -> String:
	if data.has(value_name):
		return "data"
	
	if is_property(value_name):
		return "property"
	
	return String()


func get_value_from_array(array_name : String, index : int, pop_value : bool = false):
	var array : Array = get(array_name)
	
	if index > array.size() - 1:
		return null
	
	var value = array[index]
	
	if pop_value:
		array.remove(index)
	
	return value


func get_value_index_in_array(array_name : String, value, start_index : int = 0) -> int:
	return get(array_name).find(value, start_index)


func get_value_from_dictionary(dict_name : String, key, default = null):
	return get(dict_name).get(key, default)



func is_same_type(value_name : String, value) -> bool:
	var type_one : int = typeof(get(value_name))
	var type_two : int = typeof(value)
	
	if type_one == TYPE_NIL or type_one == TYPE_OBJECT:
		return type_two == TYPE_NIL or type_two == TYPE_OBJECT
	
	if type_one == TYPE_REAL or type_one == TYPE_INT:
		return type_two == TYPE_REAL or type_two == TYPE_INT
	
	return type_one == type_two


func is_property(value_name : String) -> bool:
	for i in get_property_list():
		if i.name == value_name:
			return true
	
	return false


func is_key_in_dictionary(dict_name : String, key) -> bool:
	var dict : Dictionary = get(dict_name)
	return dict.has(key)



func get_data() -> Dictionary:
	notification(NOTIFICATION_GET_DATA, true)
	var data : Dictionary = _data_to_send.duplicate(true)
	_data_to_send = {}
	return data



func __on_data_collected(new_data : Dictionary) -> void:
	_data_to_send.merge(new_data, true)
	prints(new_data, _data_to_send)


func _on_changed_value_sent(container : String, value_name : String, value_new, value_old) -> void:
	return
