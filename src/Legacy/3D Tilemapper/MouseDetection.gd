tool
extends Area


func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")



func _on_mouse_entered() -> void:
	print("WOW")
