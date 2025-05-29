extends BaseTemplate
class_name EncounterTemplate

enum LocationType {GENERAL, PLAINS, ROAD, FOREST, FOREST_EDGE, SWAMP, WATER, 
SWAMP_WATER, CAVE, FORT, DUNGEON}

export (LocationType) var location : int
export (Array) var conditions : Array = Array()
export (String, DIR) var dialogue_folder : String setget set_dialogue_folder

var branches : Dictionary = Dictionary()



func enter_folder(folder_path : String) -> Directory:
	var folder : Directory = Directory.new()
	var path : String = folder_path if folder_path.is_abs_path() else dialogue_folder + "/" + folder_path
	
	if not folder.open(path) == OK:
		LogSystem.write_to_debug("Encounter: could not open folder at path " + folder_path, 0)
		return null
	
	return folder



func set_dialogue_folder(new_folder : String) -> void:
	dialogue_folder = new_folder
	branches.clear()
	
	var dir : Directory = enter_folder(dialogue_folder)
	
	if dir == null:
		return
	
	dir.list_dir_begin(true)
	
	var folder_name : String = dir.get_next()
	
	while not folder_name.empty():
		var folder_dir : Directory = enter_folder(folder_name)
		
		if folder_dir:
			branches[folder_name] = folder_dir
		
		folder_name = dir.get_next()
	
	dir.list_dir_end()
	
	if not has_dialogue("start"):
		LogSystem.write_to_debug("Encounter: no start folder found.", 0)



func has_dialogue(dialogue_name : String) -> bool:
	return branches.has(dialogue_name)



func get_flags(type : String = "LOCAL") -> Dictionary:
	var flags : Dictionary = {}
	
	if branches.empty():
		return {}
	
	for i in branches:
		for j in i.answers:
			if j.flag_name and j.flag_type == type:
				flags[j.flag_name] == false
	
	if flags.empty():
		LogSystem.write_to_debug("Encounter: No flags found.", 0)
	
	return flags



func get_dialogue_from_folder(name : String) -> DialogueTemplate:
	if not has_dialogue(name):
		LogSystem.write_to_debug("Encounter: no dialogue with name of " + name, 0)
		return null
	
	var dialogue : Directory = branches[name]
	dialogue.list_dir_begin(true)
	
	var file_name : String = dialogue.get_next()
	
	while not file_name.empty():
		if not file_name.get_extension():
			file_name = dialogue.get_next()
			continue
		
#		var file = load(dialogue.get_current_dir() + "/" + file_name)
#
#		if file is DialogueTemplate:
#			dialogue.list_dir_end()
#			return file
#
#		file_name = dialogue.get_next()
	
	dialogue.list_dir_end()
	return null


#func get_answers_from_folder(name : String) -> Array:
#	if not has_dialogue(name):
#		LogSystem.write_to_debug("Encounter: no dialogue with name of " + name)
#		return Array()
#
#	var dialogue : Directory = branches[name]
#	dialogue.list_dir_begin(true)
#
#	var file_name : String = dialogue.get_next()
#
#	while not file_name.empty():
#		var file : Resource = load(dialogue.get_current_dir() + "/" + file_name)
#
#		if file and file is DialogueTemplate:
#			dialogue.list_dir_end()
#			return file.get_answers()
#
#	dialogue.list_dir_end()
#	return Array()


func get_start() -> DialogueTemplate:
	return get_dialogue_from_folder("start")
