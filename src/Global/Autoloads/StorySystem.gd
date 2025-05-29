extends Node

var action : int = 0
var intensity : int = 0
var drama : int = 0
var locations : Dictionary = {}
var encounter_list : Dictionary = {}
var global_flags : Dictionary = {}
var characters : Dictionary = {
	acquiantances = [],
	allies = [],
	rivals = [],
	villians = [],
	dead = [],
}
var _encounter_pool : Array = []



func add_encounter(new_encounter : Resource, priority : int = -1) -> void:
	return


func add_character(new_character : Resource, to_list : String) -> void:
	return


func add_global_flag(encounter : Resource, flag_name : String) -> void:
	if not global_flags.get(encounter):
		global_flags[encounter] = []
	
	global_flags[encounter].append(flag_name)



func get_flags_from_encounter(encounter : Resource) -> Array:
	return global_flags.get(encounter, [])
