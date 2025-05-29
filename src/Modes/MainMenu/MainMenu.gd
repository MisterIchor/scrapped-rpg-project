extends Control



func _ready() -> void:
	$MarginContainer/VBoxContainer/NewGameButton.connect("pressed", self, "_on_NewGameButton_pressed")
	$MarginContainer/VBoxContainer/LoadGameButton.connect("pressed", self, "_on_LoadGameButton_pressed")
	$MarginContainer/VBoxContainer/QuitGameButton.connect("pressed", self, "_on_QuitGameButton_pressed")
	$MarginContainer/AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")



func _on_NewGameButton_pressed():
	get_tree().change_scene("res://src/Modes/CharacterCreation/CharCreation.tscn")


func _on_LoadGameButton_pressed():
	$MarginContainer/FileDialog.show()


func _on_QuitGameButton_pressed():
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name):
	anim_name = "Fade in"
	$MarginContainer/AnimationPlayer/ColorRect.visible = false
