extends ColorRect

onready var popup : PopupPanel = ($Popup as PopupPanel)



func _ready() -> void:
	popup.popup()
