tool
extends Label
class_name IncrementingText

#enum State {INCREMENTING, IDLE, INTERRUPT}

signal incremented(new_value)

export (bool) var add_percentage_sign : bool = false setget _E
export (bool) var show_max : bool = false setget _A
export (String) var descriptor : String = "" setget _Sports

var max_value : int = -1
var _increment_to : int = -1 setget increment_to
var _current_value : int = -1



func _ready() -> void:
	set_process(false)
	align = Label.ALIGN_CENTER
	_update_text()


func _process(_delta: float) -> void:
	_current_value += 1 if _current_value < _increment_to else -1
	_update_text()
	emit_signal("incremented", _current_value)
	
	if _current_value == _increment_to:
		set_process(false)


func _E(value : bool) -> void:
	add_percentage_sign = value
	_update_text()


func _A(value : bool) -> void:
	show_max = value
	_update_text()


func _Sports(value : String) -> void:
	descriptor = value
	_update_text()


func _update_text() -> void:
	text = str(_current_value)
	
	if not max_value <= -1 and show_max:
		text = str(text, "/", max_value)
	
	if add_percentage_sign:
		text = str("%", text)
	
	if not descriptor.empty():
		text = str(text, " ", descriptor)


func increment_to(new_int : int) -> void:
	_increment_to = new_int
	
	if not _increment_to == _current_value:
		set_process(true)
