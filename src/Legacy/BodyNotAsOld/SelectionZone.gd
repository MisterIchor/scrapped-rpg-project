extends ColorRect



func _init() -> void:
	connect("gui_input", self, "_gui_input")



func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if not BattleSystem.is_turn_processing():
			BattleSystem.set_selected_soul(owner.soul)
