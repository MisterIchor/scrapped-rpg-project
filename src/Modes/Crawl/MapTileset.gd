extends TileMap

func get_tile_name(pos : Vector2) -> String:
	return tile_set.tile_get_name(get_cell(pos.x, pos.y))


func check_direction(start : Vector2, end : Vector2, include_all_tiles : bool = false) -> PoolVector2Array:
	var pos : Vector2 = start
	var detected_rooms : PoolVector2Array
	var length : float = start.distance_to(end)
	var dir : Vector2 = start.direction_to(end)
	
	prints(length, dir)
	
	for _i in range(length):
		pos += dir
		if include_all_tiles:
			detected_rooms.append(pos)
		elif get_tile_name(pos) == "Room":
			detected_rooms.append(world_to_map(pos))
			break
	
	print(detected_rooms)
	return detected_rooms

func check_cardinal_points(room : Vector2) -> Array:
	var detected_rooms : Array
	
	detected_rooms.append(check_direction(room, room + Vector2(0,10)))
	detected_rooms.append(check_direction(room, room + Vector2(10,0)))
	detected_rooms.append(check_direction(room, room + Vector2(0,-10)))
	detected_rooms.append(check_direction(room, room + Vector2(-10,0)))

	for i in detected_rooms.count(Vector2(0,0)):
		detected_rooms.remove(detected_rooms.find(Vector2(0,0)))
	
	print("Rooms found: ", detected_rooms)
	return detected_rooms

func check_surroundings(room : Vector2) -> PoolVector2Array:
	#Subtract 1  from x and y to center detection radius.
	var pos : Vector2 = room - Vector2(1, 1)
	var detected_rooms : PoolVector2Array

	for _i in range(3):
		for _j in range(3):
			if pos != room:
				if get_cell(pos.x, pos.y) == 1:
					detected_rooms.append(pos)
			pos += Vector2(0, 1)
		pos += Vector2(1, 0)
		pos -= Vector2(0, 3)
	return detected_rooms

func create_map_from_tiles(tiles : Array) -> void:
	var pos : Vector2 = Vector2(-1,-1)
	var is_encounter : bool = false
	var is_hallway : bool = false
	
	clear()
	
	for i in tiles:
		pos = i[0]
		is_encounter = bool(i[1])
		is_hallway = bool(i[2])
		
		if is_hallway and is_encounter:
			set_cell(pos.x, pos.y, 7)
		elif is_encounter:
			set_cell(pos.x, pos.y, 2)
		elif is_hallway:
			set_cell(pos.x, pos.y, 3)
		else:
			set_cell(pos.x, pos.y, 1)
