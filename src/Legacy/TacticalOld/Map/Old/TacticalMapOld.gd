extends "PathMaker.gd"

signal path_sent(node, path)

onready var spawn_map : TileMap = ($SpawnMap as TileMap)



func _ready() -> void:
	spawn_map.hide()



func toggle_spawn_points() -> void:
	spawn_map.set_visible(!spawn_map.is_visible())



func get_list_of_spawn_points() -> Dictionary:
	return spawn_map.spawn



func _on_point_reached(new_position : Vector2, node : Node) -> void:
	obstacle_map.update_character_position(node, new_position)


func _on_path_requested(point_one, point_two, node) -> void:
	LogSystem._write_to_log("debug", str("Path requested by: ", node.name))
	
	var path : Array = get_path_to_point(point_one, point_two)
	
	path = get_body_ready_paths(path)
	
	emit_signal("path_sent", node, path)
