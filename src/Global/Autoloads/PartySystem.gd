extends Node

var selected_soul : Node = null setget set_selected_soul, get_selected_soul
var party_members : Array = [] setget , get_party_members

signal party_member_added(new_member)
signal member_stat_changed



func _enter_tree() -> void:
	add_character(String(), load("res://src/Entities/Character/Preset/SoulWithBody.gd"))
	get_leader().add_trait(load("res://src/Resources/Soul/Traits/Physical/Lightweight.tres"))
#	add_character(String(), load("res://src/Entities/Character/Preset/MainStats.gd"))
#	yield(get_tree().create_timer(2.0), "timeout")
#	party_members[0].set_value_in_container("strength", "current", 100)
#	yield(get_tree().create_timer(0.5), "timeout")
#	party_members[0].set_value_in_container("strength", "current", 0)
#	add_character(String(), load("res://src/Entities/Physical/Character/Preset/MainStats.gd"))
#	add_character(String(), load("res://src/Entities/Physical/Character/Preset/MainStats.gd"))
#	add_character(String(), load("res://src/Entities/Physical/Character/Preset/MainStats.gd"))
#	party_members[0].set_value_in_container("soul_name", "full_name", "Sharashka Aldimir")
#	party_members[0].set_value_in_container("soul_name", "nickname", "Lapse")
#	party_members[0].set_value_in_container("appearance", "eye_color", Color.purple)
#	party_members[0].set_value_in_container("appearance", "hair_color", Color.wheat)
#	party_members[1].set_value_in_container("soul_name", "full_name", "William Sparx")
#	party_members[1].set_value_in_container("soul_name", "nickname", "Goggles")
#	party_members[1].set_value_in_container("appearance", "eye_color", Color.green)
#	party_members[1].set_value_in_container("appearance", "hair_color", Color.yellow)
#	party_members[1].set_value_in_container("appearance", "custom_portrait", "res://assets/portraits/WilliamPortrait.PNG")
#	party_members[2].set_value_in_container("appearance", "custom_portrait", "res://assets/portraits/HarryPortrait.PNG")
#	party_members[3].set_value_in_container("appearance", "custom_portrait", "res://assets/portraits/JamesPortrait.PNG")
#	yield(get_tree().create_timer(1.0), "timeout")
#	party_members[0].increment_value_in_container("health", "current", -32)
#	party_members[1].increment_value_in_container("health", "current", -10)
#	party_members[2].increment_value_in_container("health", "current", -50)
#	party_members[3].set_value_in_container("health", "current", 0)
#	party_members[4].set_value_in_container("appearance", "custom_portrait", load("res://assets/portraits/Willows.PNG"))
#	add_character(String(), load("res://src/Entities/Character/Soul/Preset/Base.gd"))
#	add_character(String(), load("res://src/Entities/Character/Soul/Preset/Base.gd"))
	
#	party_members[1].set_agility(100)
#	party_members[1].set_soul_name("James Futureperson")
#	party_members[2].set_charisma(0)
#	party_members[2].set_soul_name("Erik Ancientguy")



func _ready() -> void:
	ConsoleSystem.add_to_console(self)



func add_character(path_to_preset : String = String(), soul_script : Resource = load("res://src/Entities/Character/Soul.gd")) -> void:
	var new_character : Soul = soul_script.new()
	
	new_character.set_owner(self)
	party_members.append(new_character)
	
	if not path_to_preset.empty():
		new_character._set_preset(load(path_to_preset))
	
#	ConsoleSystem.add_node_to_console(new_character)


func remove_character(character_name : String) -> void:
	var character : Node = get_character(character_name)
	
	if get_character(character_name):
		ConsoleSystem.remove_node_from_console(character)
		remove_child(get_node(character_name))



func set_selected_soul(new_soul : Node) -> void:
	return



func get_leader() -> Soul:
	return party_members.front()


func get_party_member_index(member : Soul) -> int:
	return party_members.find(member)


func get_party_members() -> Array:
	return party_members


func get_party_size() -> int:
	return party_members.size()


func get_selected_soul() -> Node:
	return selected_soul


func get_character(character_name : String) -> Node:
	var character : Node = get_node_or_null(character_name)
	
	if not character:
		LogSystem.write_to_debug("Error: Could not find character %s" % character_name, 0)
	
	return character
