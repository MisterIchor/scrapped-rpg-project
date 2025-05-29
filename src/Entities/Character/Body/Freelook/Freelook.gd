extends Node2D

var action : ActionType = null setget set_action



func set_action(new_action : ActionType) -> void:
	action = new_action
	action.connect("action_finished", self, "_on_action_finished")



func _on_action_finished() -> void:
	queue_free()
