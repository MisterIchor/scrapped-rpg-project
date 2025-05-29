extends Node

const DialogueScreen : PackedScene = preload("res://src/Modes/Encounter/Dialogue/Dialogue.tscn")
const TacticalScreen : PackedScene = preload("res://src/Modes/Encounter/Tactical/TacticalScreen.tscn")

var template : EncounterTemplate = null setget set_template
var local_flags : Array = []



func _init() -> void:
	randomize()


func _ready() -> void:
	set_template(load("res://src/Resources/Encounter/test/test.tres"))




func add_dialogue_screen() -> Node:
	if has_node("Dialogue"):
		return null
	
	var dialogue : Node = DialogueScreen.instance()
	
#	connect("flag_exists", dialogue, "_on_Encounter_flag_exists")
	dialogue.connect("dialogue_changed", self, "_on_DialogueScreen_dialouge_changed")
	dialogue.connect("dialogue_finished", self, "_on_dialogue_finished")
	dialogue.connect("flag_acquired", self, "_on_flag_acquired")
	add_child(dialogue, true)
	return dialogue


func add_tactical_screen() -> Node:
	return null



func set_template(new_template : EncounterTemplate) -> void:
	template = new_template
	
	if template.dialogue_folder.empty():
		LogSystem.write_to_debug("No dialogue folder defined, returning.", 0)
		return
	
	add_dialogue_screen().go_to(template.get_start())



func _on_DialogueScreen_dialouge_changed(answer : AnswerTemplate, _next_dialogue : DialogueTemplate) -> void:
	if answer.end_dialogue:
		get_tree().quit()


func _on_dialogue_ended(end_type) -> void:
	return
