extends VBoxContainer



func _process(delta: float) -> void:
	$TimeLeft.text = "Time Left: " + str(BattleSystem.turn_timer.time_left)
	
	if BattleSystem.is_turn_processing():
		$Status.text = "Turn Status: Executing turn"
	else:
		$Status.text = "Turn Status: Player's Turn"
