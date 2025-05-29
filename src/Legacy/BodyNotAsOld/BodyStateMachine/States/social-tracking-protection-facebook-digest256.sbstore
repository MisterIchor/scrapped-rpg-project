tool
extends "res://src/StateMachine/StateMachine.gd"

var soul : Soul = null setget set_soul
var path_finder : Path2D = null setget set_path_finder
var path_follower : PathFollow2D = null setget set_path_follower

#func _change_state(state : EnhancedObject) -> void:
#	._change_state(state)
#	match state.name:
#		"Moving":
#			if not path_finder.get_current_size():
#				LogSystem._write_to_log("debug", str(owner.name, ": No path left to follow"))
#				set_current_state("selected")
#				return
#
#		"Selected":
#			if path_finder:
#				if path_finder.get_current_size() and current_state.name == "Moving":
#					yield(path_follower, "point_reached")
#
#		"Turning", "AutoTurning":
#			if not owner.soul.get_current_action_points() >= 2:
#				LogSystem._write_to_log("debug", str(owner.name, ": No action points left."))
#				set_current_state("selected")
#				return




func set_path_finder(path_2d : Path2D) -> void:
	path_finder = path_2d


func set_path_follower(path_follow_2d : PathFollow2D) -> void:
	path_follower = path_follow_2d


func set_soul(new_soul : Soul) -> void:
	soul = new_soul



func _on_PathFinder_last_point_reached() -> void:
	if get_current_state() == "moving":
		set_current_state("selected")


func _on_PathFollower_turning_finished() -> void:
	set_current_state("previous")


func _on_PathFollower_point_reached() -> void:
	if get_current_state() == "moving":
		if not path_follower._dir_current == path_finder.get_next_direction():
			set_current_state("auto_turning")
	
	if not owner.soul.get_current_action_points() >= 4:
		set_current_state("selected")
