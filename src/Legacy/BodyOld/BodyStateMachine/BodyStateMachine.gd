tool
extends "res://src/StateMachine/StateMachine.gd"

var path_finder : Path2D = null setget set_path_finder
var path_follower : PathFollow2D = null setget set_path_follower




func _change_state(state : Reference) -> void:
	match state.name:
		"Moving":
			if not path_finder.get_current_size():
				LogSystem._write_to_log("debug", str(owner.name, ": No path left to follow"))
				set_current_state("selected")
				return
			
			if not owner.soul.get_current_action_points() >= 4:
				LogSystem._write_to_log("debug", str(owner.name, ": No action points left."))
				set_current_state("selected")
				return
		
		"Selected":
			if path_finder:
				if path_finder.get_current_size() and current_state.name == "Moving":
					yield(path_follower, "point_reached")
		
		"Turning", "AutoTurning":
			if not owner.soul.get_current_action_points() >= 2:
				LogSystem._write_to_log("debug", str(owner.name, ": No action points left."))
				set_current_state("selected")
				return
	._change_state(state)



func set_path_finder(path_2d : Path2D) -> void:
	path_finder = path_2d
	
	if not path_finder.is_connected("last_point_reached", self, "_on_PathFinder_last_point_reached"):
		path_finder.connect("last_point_reached", self, "_on_PathFinder_last_point_reached")


func set_path_follower(path_follow_2d : PathFollow2D) -> void:
	path_follower = path_follow_2d
	path_follower.connect("turning_finished", self, "_on_PathFollower_turning_finished")
	path_follower.connect("point_reached", self, "_on_PathFollower_point_reached")



func _on_selection_changed(is_selected : bool) -> void:
	set_current_state("selected" if is_selected else "idle")


func _on_PathFinder_last_point_reached() -> void:
	if get_current_state() == "moving":
		set_current_state("selected")


func _on_PathFollower_turning_finished() -> void:
	set_current_state("previous")


func _on_PathFollower_point_reached(_new_position : Vector2) -> void:
	if get_current_state() == "moving":
		if not path_follower._dir_current == path_finder.get_next_direction():
			set_current_state("auto_turning")
	
	if not owner.soul.get_current_action_points() >= 4:
		set_current_state("selected")
