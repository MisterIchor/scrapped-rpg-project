tool
extends Node

export (Array, Resource) var state_list : Array = []

var current_state : EnhancedObject
var previous_state : EnhancedObject
var is_ai_controlled : bool = false setget set_ai_controlled

var _active : bool = false setget set_active

signal state_changed(new_state, previous_state)



func _ready() -> void:
	if Engine.editor_hint:
		return
	
	if state_list.empty() and not Engine.editor_hint:
		LogSystem.write_to_debug(owner.name + ": No states are intialized. Setting active to false.", 0)
		set_active(false)
		return
	
	state_list = state_list.duplicate()
	
	for i in range(state_list.size()):
		var state_object : Action = state_list[i].new()
		
		state_object.set_owner(self)
		state_object.connect("state_finished", self, "_on_state_finished")
		
		state_list[i] = state_object
	
	_change_state(state_list.front())



func _unhandled_input(event: InputEvent) -> void:
	if not current_state:
		return
	
	current_state._handle_input(event)


func _unhandled_key_input(event: InputEventKey) -> void:
	if not current_state:
		return
	
	current_state._handle_key_input(event)


func _physics_process(delta: float) -> void:
	if not current_state:
		return
	
	current_state._handle_physics_process(delta)


func _process(delta: float) -> void:
	if not current_state:
		return
	
	current_state._handle_process(delta)


func _change_state(new_state : EnhancedObject) -> void:
	previous_state = current_state
	
	if current_state:
		current_state._exit()
	
	current_state = new_state
	
	if current_state:
		current_state._enter()
	
	emit_signal("state_changed", get_current_state(), get_previous_state())



func set_current_state(new_state : String) -> void:
	if new_state == "previous":
		_change_state(previous_state)
	else:
		_change_state(get_state(new_state))


func set_ai_controlled(value : bool) -> void:
	is_ai_controlled = value
	set_process_unhandled_input(value)
	set_process_unhandled_key_input(value)


func set_active(value : bool) -> void:
	_active = value
	set_process(_active)
	set_physics_process(_active)
	set_process_unhandled_input(_active)
	set_process_unhandled_key_input(_active)



func get_current_state() -> String:
	return current_state.name.to_lower() if current_state else "null"


func get_previous_state() -> String:
	if previous_state:
		return previous_state.name.to_lower()
	
	return get_current_state()


func get_state(state_name : String) -> EnhancedObject:
	for i in state_list:
		if i.name.matchn(state_name):
			return i
	
	return null



func _on_state_finished(next_state : String) -> void:
	set_current_state(next_state)
