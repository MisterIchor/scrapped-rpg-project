tool
extends Tween

const transitions : Array = ["Linear","Sine","Quint","Quart","Quad","Expo","Elastic","Cubic","Circ","Bounce","Back"]
const eases : Array = ["In","Out","In/Out","Out/In"]

export (String, "SINGLE", "GROUP") var target_type
export (NodePath) var target_node : NodePath setget set_target_node
export (Array) var tweens : Array = []
export (bool) var play_animation : bool = false setget set_play_animation

var test_start : Dictionary = {}
var settings : Dictionary = {
	property = "",
	transition = "Linear",
	ease_type = "In/Out",
	time = 1.0
}
var previous_properties : Dictionary = {}



func _init() -> void:
	connect("tween_all_completed", self, "_on_tween_all_completed")



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "TweenSettings",
		type = TYPE_NIL,
		hint_string = "tween_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "tween_property",
		type = TYPE_STRING,
	})
	
	property_list.append({
		name = "tween_transition",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = PoolStringArray(transitions).join(",")
	})
	
	property_list.append({
		name = "tween_ease_type",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = PoolStringArray(eases).join(",")
	})
	
	property_list.append({
		name = "tween_time",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0.001,999,0.001"
	})
	
	property_list.append({
		name = "tween_add_tween",
		type = TYPE_BOOL
	})
	
	property_list.append({
		name = "tween_refresh_properties",
		type = TYPE_BOOL
	})
	
	
	property_list.append({
		name = "TestSettings",
		type = TYPE_NIL,
		hint_string = "test_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "test_set_default_variables",
		type = TYPE_BOOL
	})
	
	property_list.append({
		name = "test_play_animation",
		type = TYPE_BOOL
	})
	
	property_list.append({
		name = ""
	})
	
	return property_list


func _set(property: String, value) -> bool:
	if property == "tween_property":
		settings.property = value
	
	if property == "tween_transition":
		settings.transition = value
	
	if property == "tween_ease_type":
		settings.ease_type = value
	
	if property == "tween_time":
		settings.time = value
	
	if property == "tween_add_tween" and value == true:
		var node : Node = get_node_or_null(target_node)
		
		if not node:
			LogSystem.write_to_debug(owner.name + ": could not find node at path " + target_node, 0)
			return false
		
		if not node.get(settings.property):
			LogSystem.write_to_debug(owner.name + ": could not find property " + settings.property + " on node " + node.name, 0)
			return false
		
		var current_settings : Dictionary = settings.duplicate()
		var current_properties : Dictionary = get_target_node_properties()
		
		current_settings.node = target_node
		current_settings.to = current_properties[settings.property]
		tweens.append(current_settings)
		refresh_previous_properties()
	
	if property == "tween_refresh_properties" and value == true:
		refresh_previous_properties()
	
	return false


func _get(property: String):
	if property == "tween_property":
		return settings.property
	
	if property == "tween_transition":
		return settings.transition
	
	if property == "tween_ease_type":
		return settings.ease_type
	
	if property == "tween_time":
		return settings.time



func start_animation() -> void:
	for i in tweens:
		var node : Node = get_node_or_null(i.node)
		
		if not node:
			continue
		
		interpolate_property(node, i.property, node.get(i.property), i.to, i.time, 
				transitions.find(i.transition), eases.find(i.ease_type))
		
		test_start[node] = {property = i.property, value = node.get(i.property)}
	
	start()


func refresh_previous_properties() -> void:
	previous_properties.clear()
	
	var properties : Dictionary = get_target_node_properties()
	
	if properties.empty():
		return
	
	previous_properties = properties



func set_play_animation(value : bool) -> void:
	play_animation = value
	
	if play_animation:
		start_animation()
	else:
		stop_all()
		
		for i in tweens:
			if not i:
				continue
			
			i.set(tweens[i].property, tweens[i].value)


func set_target_node(node : NodePath) -> void:
	target_node = node
	refresh_previous_properties()



func get_target_node_properties() -> Dictionary:
	var new_node : Node = get_node_or_null(target_node)
	
	if not new_node:
		return {}
	
	var properties : Dictionary = {}
	
	for i in new_node.get_property_list():
		properties[i.name] = new_node.get(i.name)
	
	return properties



func _on_tween_all_completed() -> void:
	play_animation = false
