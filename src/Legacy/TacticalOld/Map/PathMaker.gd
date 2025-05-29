extends "TileMap.gd"

onready var obstacle_map : TileMap = ($ObstacleMap as TileMap)



func get_angle_to_point(point_one, point_two) -> int:
	return int(rad2deg(point_one.angle_to_point(point_two)))


func get_next_point(point_one : Vector2, point_two : Vector2) -> Vector2:
	var degrees : int = get_angle_to_point(point_one, point_two)
	
	match clamp(stepify(degrees, 45), -135, 180):
		0.0:
			return point_one + Vector2(-1, 0)
		45.0:
			return point_one + Vector2(-1, -1)
		90.0:
			return point_one + Vector2(0, -1)
		135.0:
			return point_one + Vector2(1, -1)
		180.0:
			return point_one + Vector2(1, 0)
		-45.0:
			return point_one + Vector2(-1, 1)
		-90.0:
			return point_one+ Vector2(0, 1)
		-135.0:
			return point_one + Vector2(1, 1)
	
	return Vector2()


func get_path_to_point(point_one : Vector2, point_two : Vector2) -> Array:
	var path : Array = [world_to_map(point_one), world_to_map(point_two)]
	var idx : int = 1
	
	while path[-2] != world_to_map(point_two):
		var point : Dictionary = {"current" : path[idx - 1], "next" : path[idx]}
		
		path.insert(path.size() - 1, get_next_point(point.current, point.next))
		idx += 1
	
	path.remove(path.size() - 1)
	return path


func get_body_ready_paths(path : Array) -> Array:
	var path_mapped : Array = []
	var path_actual : Array = [path.front(), path.back()]
	
	for i in range(path.size()):
		var a = map_to_world(path[i])
		path_mapped.append(get_center_of_tile(a))
	
	return [path_mapped, path_actual, path]

