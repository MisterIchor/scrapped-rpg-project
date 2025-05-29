extends Control

onready var animation : AnimationPlayer = ($AnimationPlayer as AnimationPlayer)
onready var progress_bar : ProgressBar = ($ProgressBar as ProgressBar)



func _ready() -> void:
	progress_bar.max_value = BattleSystem.time_between_turns



func _process(delta: float) -> void:
	progress_bar.value = BattleSystem.time_between_turns - BattleSystem.get_turn_time_left()



func _on_action_phase_started() -> void:
	if animation.is_playing():
		yield(animation, "animation_finished")
	
	animation.play("turn_in_progress")


func _on_action_phase_ended() -> void:
	if animation.is_playing():
		yield(animation, "animation_finished")
	
	animation.play("your_turn")
