extends Node

var soul : Node setget set_soul

signal path_sent(actual, mapped)
signal path_requested(point_one, point_two, node)
signal point_reached(new_position)
signal turned(new_dir)

onready var state_machine : Node = ($PathFinder/PathFollower/StateMachine as Node)
onready var path_finder : Path2D = ($PathFinder as Path2D)
onready var path_follower : PathFollow2D = ($PathFinder/PathFollower as PathFollow2D)



func _enter_tree() -> void:
	ConsoleSystem.add_node_to_console(self)


func _ready() -> void:
	connect("path_sent", path_finder, "_on_path_sent")
	path_finder.connect("path_requested", self, "_on_PathFinder_path_requested")
	path_follower.connect("point_reached", self, "_on_PathFollower_point_reached")
	path_follower.connect("turned", self, "_on_PathFollower_turned")



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		path_finder.request_path(path_follower.get_global_mouse_position(), path_finder.get_global_mouse_position())



func set_soul(new_soul : Node) -> void:
	if soul:
		soul.disconnect("selection_changed", self, "_on_Soul_selection_changed")
		disconnect("point_reached", soul, "_on_point_reached")
		disconnect("turned", soul, "_on_turned")
	
	soul = new_soul
#	set_name(str(soul.name, "Body"))
	
	soul.connect("selection_changed", self, "_on_Soul_selection_changed")
	connect("point_reached", soul, "_on_point_reached")
	connect("turned", soul, "_on_turned")


func set_character_position(new_position : Vector2) -> void:
	path_follower.set_global_position(new_position)


func set_path_color(new_color : Color) -> void:
	path_finder.path_color = new_color



func _on_Soul_selection_changed(is_selected : bool) -> void:
	if is_selected:
		state_machine.set_current_state("selected")
	else:
		state_machine.set_current_state("idle")


func _on_PathFollower_point_reached(new_position : Vector2) -> void:
	emit_signal("point_reached", new_position)


func _on_PathFollower_turned(new_dir : Vector2) -> void:
	emit_signal("turned", new_dir)


func _on_PathFinder_path_requested(point_one : Vector2, point_two : Vector2) -> void:
	emit_signal("path_requested", self, point_one, point_two)


func _on_path_sent(node : Node, actual_path : Array, mapped_path : Array) -> void:
	if not node == self:
		return
	
	emit_signal("path_sent", actual_path, mapped_path)
