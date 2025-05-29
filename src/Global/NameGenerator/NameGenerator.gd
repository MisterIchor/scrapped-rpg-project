extends EnhancedObject
class_name NameGenerator

var name_lists : Array = Array()
var catagory : Dictionary = {}
var insert : Dictionary = {}
var chance : Dictionary = {}
var parser : Parser = Parser.new(self, null)



func _init(name_list_to_intialize : String = String()) -> void:
	set_name("NameGenerator")
	
	if not name_list_to_intialize == String():
		add_name_list(load_name_list(name_list_to_intialize))
	
	randomize()



func add_name_list(new_list : File) -> void:
	name_lists.append(new_list)
	load_names_from_list(new_list)


func load_name_list(path_to_list : String) -> File:
	var new_list : File = File.new()
	
	if new_list.open(path_to_list, File.READ) == OK:
		return new_list
	
	log_debug(["could not load name list at path " + path_to_list, 0])
	return null


func refresh_names() -> void:
	catagory.clear()
	chance.clear()
	insert.clear()
	
	for i in name_lists:
		load_names_from_list(i)


func generate_name(allow_repeats : bool = false) -> String:
	if catagory.empty():
		log_debug(["Cannot generate a name without a name list. Please load one.", 0])
		return String()
	
	var chosen_names : PoolStringArray = PoolStringArray()
	var name : String
	
	for i in catagory:
		var catagory_insert : Array = ["", ""]
		
		if i == "<UNDEFINED>":
			continue
		
		if i in chance:
			if not Gambler.roll() <= chance[i]:
				continue
		
		if i in insert:
			catagory_insert = insert[i]
		
		var generated_name : String = get_random_name_from_catagory(i)
		
		if not allow_repeats and chosen_names.size() > 1:
			if generated_name in chosen_names:
				var current_name : String = generated_name
				
				while generated_name == current_name:
					generated_name = get_random_name_from_catagory(i)
		
		name += catagory_insert.front()
		name += generated_name
		name += catagory_insert.back()
		
		if not i == catagory.keys()[catagory.size() - 1]: # not last catagory.
			name += " "
		
		chosen_names.append(generated_name)
	
	return name


func load_names_from_list(name_list : File) -> void:
	var section : String = "<UNDEFINED>"
	var line : String = name_list.get_line()
	
	while not name_list.eof_reached():
		if line.empty() or line.begins_with("#"):
			line = name_list.get_line()
			continue
		
		if line.begins_with("<") and line.ends_with(">"):
			section = line
			line = name_list.get_line()
			continue
		
		if line.begins_with("+"):
				line = line.lstrip("+")
				var addition : PoolStringArray = line.split(" ")
				
				parse_addition(section, addition)
				line = name_list.get_line()
				continue
		
		if not catagory.get(section):
			catagory[section] = []
		
		catagory[section].append(line)
		line = name_list.get_line()
	
	if catagory.get("<UNDEFINED>"):
		log_debug(["The following names were defined before a section. Please place them under a section.", 0])
		
		for i in catagory["<UNDEFINED>"]:
			LogSystem.write_to_debug(i, 0)


# TODO: use parser instead.
func parse_addition(catagory : String, addition : Array) -> void:
	match addition[0]:
		"load":
			var new_list : File = load_name_list(addition[1])
			
			if new_list:
				load_names_from_list(new_list)
		"chance":
			chance[catagory] = int(addition[1])
		"insert":
			if not insert.get(catagory):
				insert[catagory] = ["", " "]
			
			match addition[1]:
				"front":
					insert[catagory][0] = addition[2]
				"back":
					insert[catagory][1] = addition[2]



func get_random_name_from_catagory(catagory_name : String) -> String:
	if catagory_name in catagory:
		var selected_catagory : Array = catagory[catagory_name]
		
		if selected_catagory.size() < 1:
			log_debug(["no names found in catagory " + catagory_name, 0])
			return String()
		
		return selected_catagory[randi() % selected_catagory.size()]
	
	log_debug(["catagory " + catagory_name + " not found.", 0])
	return String()
