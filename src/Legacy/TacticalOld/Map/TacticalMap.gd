tool
extends "TileMap.gd"

export (Vector2) var map_size : Vector2 = Vector2(32, 32) setget set_map_size

var waypoints : Array = []
var connected_paths : Array = []
var selected_path : Array = []

onready var ground_map : TileMap = ($GroundMap as TileMap)
onready var spawn_map : TileMap = ($SpawnMap as TileMap)
onready var obstacle_map : TileMap = ($ObstacleMap as TileMap)
onready var astar : AStar2D = AStar2D.new()

signal path_sent(node, path)



#func _enter_tree() -> void:
#	var camera : Camera2D = Camera2D.new()
#
#	add_child(camera)
#	camera.set_position(Vector2(6, 498))
#	camera.set_zoom(Vector2(1.6, 1.6))
#	camera._set_current(true)


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	add_walkable_tiles(get_obstacles())
	connect_all_tiles()



func _draw():
	if Engine.editor_hint:
		var lines_to_draw : Array = [
			Vector2(0, 0),
			map_to_world(Vector2(map_size.x, 0)),
			map_to_world(map_size),
			map_to_world(Vector2(0, map_size.y)),
			Vector2(0, 0)
		]
		draw_polyline(lines_to_draw, Color(1,1,1))
	
#	if OS.is_debug_build():
#		if selected_path:
#			draw_polyline(selected_path, Color(0, 0, 0))
#
#		for i in waypoints:
#			draw_circle(i, 1, Color(1, 1, 1))
#
#		for i in connected_paths:
#			for j in i:
#				if not j in selected_path:
#					draw_line(i[0], i[1], Color(0.5, 0.5, 0.5))



#func _input(event):
#	if OS.is_debug_build():
#		if event.is_action_pressed("select"):
#			selected_path = get_walkable_path(Vector2(0, 0), get_global_mouse_position())
#			print(selected_path)
#			update()



func add_walkable_tiles(obstacles : Array) -> void:
	waypoints.clear()
	
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point : Vector2 = get_center_of_tile(map_to_world(Vector2(x, y)))
			
			if point in obstacles:
				continue
			
			var index : int = calculate_point_index(point)
			
			if astar.has_point(index):
				LogSystem.write_to_debug("TacticalMap: Point with index " + str(index) + " at position " + str(astar.get_point_position(index)) + " already exists.")
				continue
			
			astar.add_point(calculate_point_index(point), point)
	
	LogSystem.write_to_debug("TacticalMap: Waypoints intialized.")
	
	for i in astar.get_points():
		waypoints.append(astar.get_point_position(i))
		update()



func connect_all_tiles() -> void:
	for i in astar.get_points():
		var point : Vector2 = astar.get_point_position(i)
		
		for j in Directions:
			var point_dir : Vector2 = point + Directions[j]
			var point_dir_index : int = calculate_point_index(point_dir)
			
			if astar.has_point(point_dir_index):
				astar.connect_points(i, point_dir_index)
				connected_paths.append([point, point_dir])
	
	LogSystem.write_to_debug("TacticalMap: Waypoints connected.")


func calculate_point_index(point : Vector2) -> float:
	return point.x + map_size.x * point.y * map_size.y



func set_map_size(new_size : Vector2) -> void:
	map_size = new_size
	update()



func get_ground_tiles() -> Array:
	return ground_map.get_used_cells()


func get_obstacles() -> Array:
	return obstacle_map.get_list_of_obstacles_world()


func get_spawn_points() -> Array:
	return spawn_map.get_spawn_points()


func get_walkable_path(point_one : Vector2, point_two : Vector2) -> PoolVector2Array:
	var point_one_index : int = astar.get_closest_point(point_one)
	var point_two_index : int = astar.get_closest_point(point_two)
	
	if point_one_index in astar.get_points() and point_two_index in astar.get_points():
		return astar.get_point_path(point_one_index, point_two_index)
	
	return PoolVector2Array()



func _on_path_requested(node : Node, point_one : Vector2, point_two : Vector2) -> void:
	emit_signal("path_sent", node, get_walkable_path(point_one, point_two))
