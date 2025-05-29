extends Node

var modes : Dictionary = {
	character_creation = preload("res://src/Modes/CharacterCreation/CharCreation.tscn"),
	encounter = preload("res://src/Modes/Encounter/Encounter.tscn"),
	crawl = preload("res://src/Modes/Crawl/MapScreen.tscn"),
	main_menu = preload("res://src/Modes/MainMenu/MainMenu.tscn"),
#	travel = preload("res://src/Modes/WorldMap/TravelScreen.tscn")
}
var _current_mode : String = "undefined"
var _current_mode_scene : Node = null


#func start_encounter(encounter_template : EncounterTemplate) -> void:
#	var encounter : Node = Encounter.new()
#
#	encounter.template = encounter_template



func set_mode(mode : String) -> void:
	if get_current_mode() == mode:
		return
	
	var new_mode : PackedScene = modes.get(mode)
	
	if not new_mode:
		return
	
	if not get_tree().change_scene_to(new_mode) == OK:
		LogSystem.write_to_log("debug", "Critical Error: could not start encounter.")
		return
	
	_current_mode = mode
	_current_mode_scene = get_tree().current_scene



func get_current_mode() -> String:
	return _current_mode


func get_current_mode_scene() -> Node:
	return _current_mode_scene
