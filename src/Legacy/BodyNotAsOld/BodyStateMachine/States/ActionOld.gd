extends "res://src/StateMachine/State.gd"
#class_name Action

enum ActionTypes {OFFENSIVE, DEFENSIVE, MOVE, INTERUPTABLE}
enum StaminaRateTypes {CONST, INIT}

var action_type : int = ActionTypes.OFFENSIVE
var can_lead_into : Array = []
var containers_used : Dictionary = {}
var description : String = ""
var stamina_rate : int = 0
var stamina_rate_type : int = StaminaRateTypes.CONST
var body_info : DataContainer = null

signal action_confirmed()



func _init() -> void:
	messages.no_body_info_found = ["No body info found.", 0]
	messages.no_soul_found = ["No soul found? Oh fuck.", 0]
	messages.no_path_finder_found = ["No pathfinder found.", 0]
	messages.no_path_follower_found = ["No pathfollower found.", 0]
	messages.no_personal_space_found = ["No personal space? Wierdo.", 0]
	messages.container_used_null = ["Null value found in place of %s.", 0]
	
	for i in containers_used:
		if containers_used[i] == null:
			log_debug(messages.container_used_null, [i])


func _selected(event : InputEvent) -> void:
	return


func _confirmed() -> void:
	return


func _enter() -> void:
	if stamina_rate_type == StaminaRateTypes.INIT:
		var stamina : Stat = get_container("stamina")
		stamina.increment_current_value(stamina_rate)


func _handle_process(delta : float) -> void:
	var stamina : Stat = get_container("stamina")
	
	if stamina:
		if stamina_rate_type == StaminaRateTypes.INIT:
			stamina.increment_current_value(stamina_rate)



func set_value_in_container(container_name : String, value_name : String, value) -> void:
	var container : DataContainer = get_container(container_name)
	
	if not container:
		return
	
	container.set(value_name, value)



func get_container(container_name : String) -> DataContainer:
	for i in containers_used:
		if i.matchn(container_name):
			return containers_used[i]
	
	if not get_soul():
		return null
	
	var container : DataContainer = get_soul().get_container(container_name)
	
	if not container in containers_used:
		containers_used[container_name] = container
	
	return container


func get_value_from_container(container_name : String, value_name : String):
	if not get_soul():
		return null
	
	return get_soul().get_value_from_container(container_name, value_name)


func get_body() -> Node:
	return owner.owner


func get_body_info() -> DataContainer:
	if not get_body().body_info:
		log_debug(messages.no_body_info_found)
	
	return get_body().body_info


func get_path_finder() -> Path2D:
	return get_body_info().get("path_finder")


func get_path_follower() -> PathFollow2D:
	return get_body_info().get("path_follower")


func get_soul() -> Soul:
	if not get_body().soul:
		log_debug(messages.no_soul_found)
	
	return get_body().soul


#func get_personal_space() -> RayCast2D:
#	if not owner:
#		yield(self, "owner_set")
#
#	if not owner.personal_space:
#		log_debug(messages.no_personal_space_found)
#
#	return owner.personal_space


func get_unit_offset() -> float:
	if not get_path_follower():
		return 1.0
	
	return get_path_follower().unit_offset


func get_current_path() -> Dictionary:
	if not get_path_finder():
		return {}
	
	return get_path_finder().current_path


func get_full_path() -> Array:
	if not get_path_finder():
		return []
	
	return get_path_finder().full_path


func get_mouse_position() -> Vector2:
	if not get_path_finder():
		return Vector2()
	
	return get_path_finder().get_global_mouse_position()
