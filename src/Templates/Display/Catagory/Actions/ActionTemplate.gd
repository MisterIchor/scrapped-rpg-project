tool
extends CatagoryTemplate
class_name ActionTemplate

signal finished

export (Array, GDScript) var action_scripts : Array = [] setget set_action_scripts
export (Dictionary) var configurable_values : Dictionary = {}



func set_action_scripts(new_scripts : Array) -> void:
	action_scripts = new_scripts
	
	if Engine.editor_hint:
		for i in action_scripts:
			if not i:
				continue
			
			var name : String = i.resource_path.get_file()
			
			if not name in configurable_values:
				configurable_values[name] = {}
			
			var action_object = i.new()
			
			for j in action_object.get_configurable_values():
				configurable_values[name][j] = action_object.get(j)
	
	property_list_changed_notify()



func create_action_script_objects() -> Dictionary:
	var script_array : Dictionary = {}
	
	for i in action_scripts:
		var action_object = i.new()
		var values_to_set : Dictionary = configurable_values.get(i.resource_path.get_file(), {})
		
		if not values_to_set.empty():
			for j in values_to_set:
				action_object.set(j, values_to_set[j])
		
		script_array[action_object.get_script_name()] = action_object
	
	return script_array
