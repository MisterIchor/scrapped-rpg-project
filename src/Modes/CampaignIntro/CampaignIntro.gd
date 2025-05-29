extends Control

enum AnimationCurrent {NONE, REVEAL, FADE_ALL}

var lines : PoolStringArray = [
	"The year is 40000 AT.",
	"Criminal activity is at an all-time high within Union territory.",
	"Civil unrest becomes rampant as the Union enforces stricter policies and deligating more of their forces to their cities.",
	"Recent events have tarnished the image of the Union, making many doubt it’s ability to protect it's citizens."
]
var _line_idx : int = 0
var _current_animation : int = AnimationCurrent.NONE
var _font : DynamicFont = DynamicFont.new()

onready var tween : Tween = ($Tween as Tween)
onready var timer : Timer = ($Timer as Timer)
onready var intro_text : VBoxContainer = ($IntroText as VBoxContainer)



func _init() -> void:
	_font.font_data = load("res://assets/fonts/Perfect DOS VGA 437.ttf")
	_font.size = 22


func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")
	tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	create_lines()
	reveal_line()



func create_lines() -> void:
	if lines.empty():
		return
	
	for i in intro_text.get_children():
		i.queue_free()
	
	_line_idx = 0
	
	for i in lines:
		var new_label : Label = Label.new()
		
		new_label.align = Label.ALIGN_CENTER
		new_label.valign = Label.VALIGN_TOP
		new_label.size_flags_vertical = SIZE_EXPAND
		new_label.text = i
		new_label.autowrap = true
		new_label.modulate = Color(1, 1, 1, 0)
		new_label.set("custom_fonts/font", _font)
		intro_text.add_child(new_label)


func fade_all() -> void:
	for i in intro_text.get_children():
		tween.interpolate_property(i, "modulate", Color(1, 1, 1, 1), 
				Color(1, 1, 1, 0), 3.0)
	
	_current_animation = AnimationCurrent.FADE_ALL
	tween.start()


func reveal_line(instant : bool = false) -> void:
	if instant:
		if tween.is_active():
			tween.stop_all()
			intro_text.get_child(_line_idx).modulate(Color(1, 1, 1, 1))
	else:
		tween.interpolate_property(intro_text.get_child(_line_idx),
				"modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.0)
		tween.start()
	
	_current_animation = AnimationCurrent.REVEAL
	_line_idx += 1



func _on_Timer_timeout() -> void:
	if not _line_idx == lines.size() - 1:
		reveal_line()
	else:
		fade_all()


func _on_Tween_all_completed() -> void:
	if _current_animation == AnimationCurrent.REVEAL:
		timer.start(3.0)
	elif _current_animation == AnimationCurrent.FADE_ALL:
		timer.start(6.0)
