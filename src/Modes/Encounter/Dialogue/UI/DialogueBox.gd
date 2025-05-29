tool
extends MarginContainer

export(bool) var show_portrait : bool = true setget set_portrait_visible

var dialogue : String = "" setget set_dialogue
var current_letter : int = 0

onready var dialogue_background : ColorRect = ($DialogueBackground as ColorRect)
onready var portrait : TextureRect = ($DialogueContainer/PortraitBackground/CharacterPortrait as TextureRect)
onready var portrait_background : TextureRect = ($DialogueContainer/PortraitBackground as TextureRect)
onready var text : Label = ($DialogueContainer/TextBox/Text as Label)
onready var dialogue_timer : Timer = ($DialogueTimer as Timer)
onready var voice : AudioStreamPlayer = ($Voice as AudioStreamPlayer)



func _ready() -> void:
	dialogue_timer.connect("timeout", self, "_on_DialogueTimer_timeout")



func play_text() -> void:
	if not dialogue_timer.is_stopped():
		dialogue_timer.stop()
	
	text.set_text("")
	
	if dialogue.empty():
		text.set_text("Error: no dialogue provided.")
		LogSystem.write_to_debug("Dialogue error: no dialogue given to play.", 0)
		return
	
	dialogue_timer.start(get_text_pause_time(dialogue[0]))



func set_dialogue_background_transparency(percentage : int) -> void:
	dialogue_background.set_self_modulate(Color(1, 1, 1, percentage * 0.01))


func set_background(new_background : Texture) -> void:
	portrait_background.set_texture(new_background)


func set_dialogue(new_dialogue : String) -> void:
	if new_dialogue == String():
		return
	
	dialogue = new_dialogue
	current_letter = 0
	play_text()


func set_portrait(new_portrait : Texture) -> void:
	portrait.set_texture(new_portrait)


func set_portrait_visible(value : bool) -> void:
	show_portrait = value
	
	if not portrait_background:
		yield(self, "ready")
	
	portrait_background.set_visible(value)



func get_text_pause_time(character : String) -> float:
	var base_time : float = 0.01 + Options.text_speed
	
	match character:
		".", "?", "!":
			base_time *= 10
		",":
			base_time *= 5
		" ":
			base_time = 0
	
	return base_time



func _on_DialogueTimer_timeout() -> void:
	if current_letter == dialogue.length():
		current_letter = 0
		dialogue_timer.stop()
		return
	
	var letter : String = dialogue[current_letter]
	
	text.text += letter
	current_letter += 1
	
	if not voice.playing:
		voice.play()
	
	dialogue_timer.start(get_text_pause_time(letter))
