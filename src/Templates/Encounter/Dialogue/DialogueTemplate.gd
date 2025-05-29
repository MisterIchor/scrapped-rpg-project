tool 
extends Resource
class_name DialogueTemplate

export (String, MULTILINE) var dialogue : String = String()
export (Array) var answers = Array() setget set_answers

# Due to cyclic references, answers are loaded by path instead of resource.
# This is only important if you are creating dialogue from the editor.
# Make sure this box is unticked once you are finished. Kinda sucks, but oh well =/
export (bool) var answers_as_resource : bool = false setget set_answers_as_resource

var image : Texture
var screen : String = "BOX"
var music : Dictionary = {
	song = null,
	volume = 100,
	pitch = 100,
}



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "Background",
		type = TYPE_NIL,
		hint_string = "bg_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "bg_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	
	property_list.append({
		name = "bg_screen",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "BOX,FULLSCREEN"
	})
	
	
	property_list.append({
		name = "music",
		type = TYPE_NIL,
		hint_string = "mu_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "mu_song",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_FILE,
		hint_string = "*.ogg",
	})
	
	property_list.append({
		name = "mu_volume",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,100"
	})
	
	property_list.append({
		name = "mu_pitch",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,200"
	})
	
	return property_list


func _set(property : String, value) -> bool:
	match property:
		"bg_image":
			image = value
		
		"bg_screen":
			screen = value
		
		"mu_song":
			music.song = value
		
		"mu_volume":
			music.volume = value
		
		"mu_pitch":
			music.pitch = value
	
	return true


func _get(property : String):
	match property:
		"bg_image":
			return image
		
		"bg_screen":
			return screen
		
		"mu_song":
			return music.song
		
		"mu_volume":
			return music.volume
		
		"mu_pitch":
			return music.pitch



func answers_to_path() -> void:
	for i in range(answers.size()):
		if answers[i] is Resource:
			if answers[i].resource_path:
				answers[i] = answers[i].resource_path


func answers_to_resource() -> void:
	for i in range(answers.size()):
		if answers[i] is String:
			if answers[i].is_abs_path():
				var object = load(answers[i])
				
				if object is AnswerTemplate:
					answers[i] = object



func set_answers(new_answers : Array) -> void:
	answers = new_answers
	
	if Engine.editor_hint:
		for i in range(answers.size()):
			if not answers[i]:
					answers[i] = Resource.new()


func set_answers_as_resource(value : bool) -> void:
	answers_as_resource = value
	answers_to_resource() if answers_as_resource else answers_to_path()
	property_list_changed_notify()
	
#	if not Engine.editor_hint:
#		assert(answers_as_resource == false, "Answers cannot be resource at runtime. Untick answers as resource.")


func get_answers() -> Array:
	return answers


func get_dialogue() -> String:
	return dialogue
