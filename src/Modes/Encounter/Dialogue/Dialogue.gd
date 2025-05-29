extends Control

const FAILSAFE : DialogueTemplate = preload("res://src/Resources/Encounter/FailsafeDialogue/failsafe.tres")

var answers_current : Array = Array()
var dialogue_current : DialogueTemplate = null
var parser : Parser = Parser.new(self, true)

onready var display : String setget set_display
onready var encounter : Node = get_parent()
onready var fullscreen : Control = ($Fullscreen as TextureRect)
onready var box : Control = ($Box as ColorRect)

signal dialogue_changed(answer, next_dialogue)
signal dialogue_finished(end_type)
signal flag_acquired(flag_name, type)



func _enter_tree() -> void:
	connect("dialogue_changed", MusicSystem, "_on_dialogue_changed")



func _ready() -> void:
	go_to(load("res://src/Resources/Encounter/test/dialogue/start/start.tres"))



func go_to(dialogue : DialogueTemplate) -> void:
	dialogue_current = dialogue
	
	if not dialogue_current:
		return
	
	var new_text : String = dialogue_current.get_dialogue()
	var additional_dialogue : PoolStringArray = []
	var answers_valid : Array = []
	
	answers_current.clear()
	parser.clear_memory()
	
	for i in dialogue_current.get_answers():
		var answer : AnswerTemplate = load(i)
		
		if not answer:
			continue
		
		if answer.InitSettings.conditions:
			if not process_conditions(answer.InitSettings.conditions):
				continue
		
		if answer.InitSettings.dialogue_to_add:
			additional_dialogue.append(answer.InitSettings.dialogue_to_add)
		
		answers_current.append(answer)
	
	for i in additional_dialogue:
		new_text += "\n \n"
		new_text += i
	
	set_display(dialogue_current.screen)
	get_display().set_dialogue(new_text)
	get_display().set_answers(answers_current)


func process_conditions(conditions : Array) -> bool:
	parser.output = true
	parser.clear_queued_instructions()
	parser.clear_memory()
	
	for j in conditions:
		var properties : Dictionary = j.get_condition_properties()
		
		parser.set_instructions(properties.instructions.new())
		parser.add_instruction(properties)
		parser.perform_instructions()
		
		if not parser.output:
			break
	
	return parser.output



func set_display(new_mode : String) -> void:
	new_mode = new_mode.capitalize()
	
	var new_display : CanvasItem = get_node_or_null(new_mode)
	
	if not new_display:
		return
	
	if not new_display.get("dialogue_box") or not new_display.get("choice_box"):
		return
	
	display = new_mode
	
	for i in get_children():
		i.hide()
	
	new_display.show()
	
	if not new_display.choice_box.is_connected("dialogue_selected", self, "_on_dialogue_selected"):
		new_display.choice_box.connect("dialogue_selected", self, "_on_dialogue_selected")


func get_display() -> Node:
	return get_node(display)



func _on_dialogue_selected(index : int) -> void:
	var answer : AnswerTemplate = answers_current[index]
	var next_dialogue : DialogueTemplate = FAILSAFE
	
#	if answer.Flag.name:
#		if not encounter.has_flag(answer.Flag.name):
#			encounter.add_flag(answer.Flag.name, answer.Flag.type, answer.Flag.checked_action)
#
	if answer.go_to:
		next_dialogue = answer.go_to
	
	parser.clear_memory()
	
	for i in answer.BranchSettings.branches:
		if process_conditions(i):
			next_dialogue = i
			break
	
	go_to(next_dialogue)
	emit_signal("dialogue_changed", answer, next_dialogue)


func _on_flag_exists() -> void:
	print("cool")
