tool
extends Node

var message : Dictionary = {
	returned = "Function returned value %s",
	not_a_function = "Error: Attempted to call non-existing function %s.",
	object_success = "Object %s loaded into console.",
	object_failure = "Error: Object %s failed to load.",
	object_exists = "Error: Object %s already loaded into console.",
	object_removed = "Object %s removed from console.",
	object_not_found = "Error: Object %s not found in console.",
}

var _loaded_objects : Dictionary = {}

onready var console : Control = preload("res://src/GlobalUI/Console/Console.tscn").instance()



func _init() -> void:
	set_pause_mode(Node.PAUSE_MODE_PROCESS)


func _ready() -> void:
	get_tree().connect("node_added", self, "_on_SceneTree_node_added", [], CONNECT_DEFERRED)
	add_child(console)



#func _unhandled_input(event: InputEvent) -> void:
#	if not Engine.editor_hint:
#		if event.is_action_pressed("toggle_console"):
#			get_tree().paused = !get_tree().paused
#			console.visible =  !console.visible


func add_to_console(object : Object, additional : PoolStringArray = [], exceptions : PoolStringArray = []) -> void:
	_loaded_objects[object] = get_valid_functions(object.get_method_list(), object.get_class())
	
	if not additional.empty():
		for i in additional:
			if object.has_method(i):
				_loaded_objects[object].append(i)
	
	object.connect("tree_exiting", self, "remove_from_console", [object], CONNECT_DEFERRED)
	LogSystem.write_to_debug(message.object_success % object.name, 3)


func remove_from_console(object : Object) -> void:
	_loaded_objects.erase(object)
	LogSystem.write_to_debug(message.object_removed % object.name, 3)


func call_function(object_name : String, function : String, arguments : Array = []) -> void:
	var object : Object = null
	
	for i in _loaded_objects:
		if i.name == object_name:
			object = i
			break
	
	if object:
		if function in _loaded_objects[object]:
			var value = object.callv(function, arguments)
			
			if value:
				call_deferred("_print_value", value)
		else:
			LogSystem.write_to_debug(message.not_a_function % function, 2)
	else:
		LogSystem.write_to_debug(message.object_not_found % object_name, 2)



func _print_value(value):
	match typeof(value):
		TYPE_ARRAY, TYPE_COLOR_ARRAY, TYPE_INT_ARRAY:
			for i in value:
				LogSystem.write_to_debug(i, 1)
			LogSystem.write_to_debug(message.returned % "Array", 1)
		
		TYPE_DICTIONARY:
			for i in value:
				LogSystem.write_to_debug(str(i, " : ", value[i]), 1)
			LogSystem.write_to_debug(message.returned % "Dictionary", 1)
		
		_:
			LogSystem.write_to_debug(message.returned % value, 1)



func get_valid_functions(method_list : Array, class_to_compare : String) -> Array:
	var valid_functions : Array = []
	var method_name : String = String()
	
	for i in method_list:
		method_name = i.name
		
		if method_name.begins_with("set") or method_name.begins_with("get"):
			valid_functions.append(method_name)
	
	for i in ClassDB.class_get_method_list(class_to_compare):
		var function_exists : bool = true
		method_name = i.name
		
		while function_exists:
			valid_functions.erase(i.name)
			function_exists = valid_functions.has(i.name)
	
	return valid_functions


static func get_valid_properties(from_object : Object) -> PoolStringArray:
	var valid_properties : PoolStringArray = []
	
	if from_object.get_script():
		for i in from_object.get_script().get_script_property_list():
			valid_properties.append(i.name)
		
		return valid_properties
	
	for i in from_object.get_property_list():
		if not i.type == TYPE_OBJECT | TYPE_NIL:
			if not i.usage < PROPERTY_USAGE_SCRIPT_VARIABLE:
				valid_properties.append(i.name) 
	
	return valid_properties


func get_loaded_objects(return_names : bool = false) -> Array:
	var objects : Array = []
	
	for i in _loaded_objects:
		objects.append(i.name)
	
	return objects


func get_list_of_functions_from_object(object_name : String) -> Array:
	var function_list : Array = []
	
	for i in _loaded_objects:
		if i.name == object_name:
			function_list = _loaded_objects[i].duplicate(true)
			break
	
	if function_list.empty():
		LogSystem.write_to_debug(message.object_not_found % object_name, 1)
	
	return function_list


func get_list_of_functions() -> Array:
	var function_list : Array = []
	
	for i in _loaded_objects:
		function_list.append(i)
	
	function_list.sort()
	return function_list



func _on_SceneTree_node_added(node : Node) -> void:
	return
	if node.owner:
		print(node.owner.name)
