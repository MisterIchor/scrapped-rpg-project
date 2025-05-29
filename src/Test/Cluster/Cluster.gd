extends TileMap

const EMP_CELL : Vector2 = Vector2(-21525, -21525)
const Dir : Dictionary = {
	UP_RIGHT = Vector2(1, -1),
	UP = Vector2(0, -1),
	UP_LEFT = Vector2(-1, -1),
	LEFT = Vector2(-1, 0),
	DOWN_LEFT = Vector2(-1, 1),
	DOWN = Vector2(0, 1),
	DOWN_RIGHT = Vector2(1, 1),
	RIGHT = Vector2(1, 0),
}

func _sort_outline(outline : Array) -> PoolVector2Array:
	var sorted_outline : PoolVector2Array = []
	var vector : Dictionary = {
		current = map_to_world(EMP_CELL.abs()),
		min = Vector2(),
		max = Vector2()
	}
	
	for i in outline:
		if i.length_squared() < vector.current.length_squared():
			vector.current = i
		
		if i.x < vector.min.x:
			vector.current.x = i.x
		
		if i.y < vector.min.y:
			vector.current.y = i.y
		
		if i.x > vector.max.x:
			vector.max.x = i.x
		
		if i.y > vector.max.y:
			vector.max.y = i.y
	
	sorted_outline.append(vector.current)
	outline.erase(vector.current)
	
	var last_dir : Vector2 = Vector2()
	
	while not outline.empty():
		var dir_checks : Array = [
			get_dir_world(Dir.RIGHT),
			get_dir_world(Dir.UP),
			get_dir_world(Dir.DOWN),
			get_dir_world(Dir.LEFT)
		]
		
		if last_dir:
			dir_checks.erase(last_dir)
			dir_checks.push_back(last_dir)
			last_dir = Vector2()
		
		for i in dir_checks:
			var dir_vector : Vector2 = vector.current
			var new_vector : bool = false
			
			while true:
				dir_vector += i
				
				if dir_vector in outline:
					vector.current = dir_vector
					sorted_outline.append(dir_vector)
					outline.erase(dir_vector)
					new_vector = true
					break
				
				if not dir_vector.x in range(vector.min.x, vector.max.x + 1):
					break
				
				if not dir_vector.y in range(vector.min.y, vector.max.y + 1):
					break
			
			if new_vector:
				last_dir = i
				break
	
	return sorted_outline



func convert_array_to_world(cell_array : PoolVector2Array) -> PoolVector2Array:
	var world_array : PoolVector2Array = []
	
	for i in cell_array:
		world_array.append(map_to_world(i))
	
	return world_array


func refresh_clusters() -> void:
	var cells : Array = get_used_cells()
	var current_cluster : Array = []
	var next_cells : Array = []
	
	if cells.empty():
		LogSystem.write_to_debug(name + ": No cells found, returning empty...", 1)
		return
	
	while true:
		var current_cell : Vector2
		
		if next_cells.empty():
			if not current_cluster.empty():
				for i in current_cluster:
					cells.erase(i)
				
				_clusters.append(current_cluster.duplicate())
				current_cluster.clear()
				
				if cells.empty():
					break
			
			current_cell = cells.pop_front()
		else:
			current_cell = next_cells.pop_front()
		
		if not current_cell in current_cluster:
			current_cluster.append(current_cell)
		
		for i in check_cell_surroundings(current_cell, [Dir.RIGHT, Dir.UP, Dir.DOWN, Dir.LEFT]):
			if not i == EMP_CELL and not i in current_cluster:
				if next_cells.size() < 2:
					next_cells.append(i)
				
				current_cluster.append(i)
	
	emit_signal("clusters_refreshed", _clusters)


func refresh_cluster_outlines() -> void:
	var outlines : Array = []
	
	for cluster in get_clusters():
		var cluster_outline : Array = []
		
		for cell in cluster:
			if not is_cell_surrounded(cell):
				for corner_dir in get_dirs_diagonal().values():
					var corner : Vector2 = get_cell_center(cell) + (get_dir_world(corner_dir) / 2)
					
					if corner in cluster_outline:
						continue
					
					if is_valid_corner(cell, corner_dir, cluster):
						cluster_outline.append(corner)
		
		outlines.append(cluster_outline)
	
	if outlines.empty():
		LogSystem.write_to_debug(name + ": No clusters found, returning empty...", 1)
		return
	
	for i in outlines.size():
		outlines[i] = _sort_outline(outlines[i])
	
	_cluster_outlines = outlines
	emit_signal("cluster_outlines_refreshed", _cluster_outlines)


func get_clusters() -> Array:
	return _clusters


func get_clusters_outline() -> Array:
	return _cluster_outlines


func is_cell_surrounded(cell : Vector2) -> bool:
	return not EMP_CELL in check_cell_surroundings(cell, Dir.values())


func is_valid_corner(cell : Vector2, corner_dir : Vector2, cluster : Array = []) -> bool:
	if not corner_dir in get_dirs_diagonal().values():
		return false
	
#	if cell == Vector2(12, 7):
#		breakpoint
	
	var cell_count : int = 0
	var corner : Vector2 = get_cell_center(cell) + (map_to_world(corner_dir) / 2)
	
	for i in get_dirs_diagonal().values():
		var dir_to_check : Vector2 = corner + (get_dir_world(i) / 2)
		
		if cluster.empty():
			if get_cellv(world_to_map(dir_to_check)) == -1:
				continue
		elif world_to_map(dir_to_check) in cluster:
			continue
		
		cell_count += 1
	
	return cell_count == 1 or cell_count == 3



