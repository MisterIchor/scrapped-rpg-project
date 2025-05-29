extends Area2D



func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("select"):
#		if not BattleSystem.in_battle and owner.soul.is_selected == false:
		owner.soul.set_is_selected(true)
