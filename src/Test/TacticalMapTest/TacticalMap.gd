tool
extends "ToolMap.gd"

onready var ground_map : TileMap = ($GroundMap as TileMap)
onready var spawn_map : TileMap = ($SpawnMap as TileMap)
onready var obstacle_map : TileMap = ($ObstacleMap as TileMap)



func _ready() -> void:
	var new_mesh : NavigationPolygonInstance = NavigationPolygonInstance.new()
	var polygon : NavigationPolygon = NavigationPolygon.new()
#	var array : Array = [
#		Vector2(),
#		map_to_world(Vector2(32, 0)),
#		map_to_world(Vector2(32, 32)),
#		map_to_world(Vector2(0, 32)),
#	]
	var obstacle_array : Array = []
#	polygon.add_outline(array)

	for i in obstacle_map.get_list_of_obstacles_mapped():
		obstacle_array.append(get_cell_points(i))

	polygon.add_outline(obstacle_array)
#	polygon.add_outline(array)
	polygon.make_polygons_from_outlines()
	print(polygon.get_vertices())
	new_mesh.set_navigation_polygon(polygon)
	navigation.add_child(new_mesh)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update()
#		print($e.get_simple_path(Vector2(16, 16), get_global_mouse_position()))



func _draw():
	if not Engine.editor_hint:
		for i in connected_paths:
			for j in i:
				draw_line(i[0], i[1], Color(0.5, 0.5, 0.5))
		
		for i in waypoints:
			draw_circle(i, 1, Color(1, 1, 1))
		
#		draw_polyline($e.get_simple_path(Vector2(16, 16), get_global_mouse_position()), Color.white)
#		draw_polyline(get_walkable_path(Vector2(16,16), get_global_mouse_position()), Color.white)



func update_character_position(body : Node, new_position : Vector2) -> void:
	obstacle_map.update_character_position(body, new_position)


func query_obstacles() -> Dictionary:
	return {}



func get_ground_tiles() -> Array:
	return ground_map.get_used_cells()


func get_obstacles() -> Array:
	return obstacle_map.get_list_of_obstacles_world()


func get_spawn_points() -> Array:
	return spawn_map.get_spawn_points()



func _on_Body_point_reached(body : Node, new_position : Vector2, next_point : Vector2) -> void:
	var old_pos : Dictionary = obstacle_map.get_character_positions()
	obstacle_map.update_character_position(body, new_position)
	
	var new_pos : Dictionary = obstacle_map.get_character_positions()
	
	for i in old_pos:
		for j in new_pos:
			var old_idx : int = calculate_point_index(old_pos[i])
			var new_idx : int = calculate_point_index(new_pos[j])
			
			if old_idx == new_idx:
				if astar.is_point_disabled(old_idx):
					astar.set_point_disabled(old_idx, false)
				
				continue
			
			if not old_idx == new_idx:
				if not astar.is_point_disabled(old_idx):
					astar.set_point_disabled(old_idx)
				
				continue
