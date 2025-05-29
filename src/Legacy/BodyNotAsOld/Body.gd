extends Node

var soul : Soul = null setget set_soul
var body_info : DataContainer = null
var queued_actions : Array = []

signal path_sent(actual, mapped)
signal path_requested(point_one, point_two, node)
signal point_reached(body, path_current)

onready var state_machine : Node = ($PathFinder/PathFollower/StateMachine as Node)
onready var path_finder : Path2D = ($PathFinder as Path2D)
onready var path_follower : PathFollow2D = ($PathFinder/PathFollower as PathFollow2D)



func _ready() -> void:
	if not soul:
		yield(get_tree(), "idle_frame")
	
	body_info.add_value("path_finder", path_finder)
	body_info.add_value("path_follower", path_follower)
	body_info.add_value("state_machine", state_machine)
	body_info.add_value("current_state", state_machine.get_current_state())
	connect("path_sent", path_finder, "_on_path_sent")
	BattleSystem.connect("battle_finished", self, "_on_battle_finished")
	state_machine.connect("state_changed", self, "_on_StateMachine_state_changed")
	path_finder.connect("path_requested", self, "_on_PathFinder_path_requested")
	path_finder.connect("point_reached", self, "_on_PathFinder_point_reached")



func set_soul(new_soul : Soul) -> void:
	soul = new_soul
	body_info = soul.add_data_container()
	body_info.set_name("BodyInfo")
	set_name(str(soul.name, "Body"))


func set_character_position(new_position : Vector2) -> void:
	path_follower.set_global_position(new_position)


func set_path_color(new_color : Color) -> void:
	path_finder.path_color = new_color



func get_character_position() -> Vector2:
	return path_follower.get_global_position()



func _on_StateMachine_state_changed(new_state : String, previous_state : String) -> void:
	body_info.set("current_state", new_state)


func _on_PathFinder_path_requested(point_one : Vector2, point_two : Vector2) -> void:
	emit_signal("path_requested", self, point_one, point_two)


func _on_PathFinder_point_reached(new_position : Vector2, next_point : Vector2) -> void:
	emit_signal("point_reached", self, new_position, next_point)


func _on_path_sent(node : Node, path : Array) -> void:
	if not node == self:
		return
	
	emit_signal("path_sent", path)


func _on_battle_finished() -> void:
	body_info.free()
