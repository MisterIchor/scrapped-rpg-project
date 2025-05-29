extends Control

onready var sound_player : AudioStreamPlayer = ($AudioStreamPlayer as AudioStreamPlayer)
onready var tab : Button = ($Button as Button)
export (String) var tab_label : String = "" setget set_tab_label
var sounds : Array = [
	preload("res://assets/sounds/items/document/flip_page_1.wav"),
	preload("res://assets/sounds/items/document/flip_page_2.wav"),
	preload("res://assets/sounds/items/document/flip_page_3.wav")
]
signal tab_pressed(node)


func _ready():
	tab.connect("pressed", self, "_on_Tab_pressed")
	set_tab_label(tab_label).resume()


func set_tab_label(new_label : String) -> void:
	tab_label = new_label
	yield()
	tab.text = tab_label


func _on_Tab_pressed():
	sound_player.set_stream(sounds[randi() % sounds.size()])
	sound_player.play()
	tab.rect_rotation = 90 if tab.rect_rotation == 270 else 270
	emit_signal("tab_pressed", self)
