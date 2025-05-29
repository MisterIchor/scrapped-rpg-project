tool
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



func _init() -> void:
	if mode == MODE_ISOMETRIC:
		Dir.UP_RIGHT /= 2
		Dir.UP_LEFT /= 2
		Dir.DOWN_RIGHT /= 2
		Dir.DOWN_LEFT /= 2



func check_cell_surroundings(cell : Vector2, dirs : Array) -> Array:
	var cells_in_dir : Array = []
	
	for i in dirs:
		if not get_cellv(cell + i) == -1:
			cells_in_dir.append(cell + i)
		else:
			cells_in_dir.append(EMP_CELL)
	
	return cells_in_dir



func get_used_cells_info() -> Dictionary:
	var cells : Dictionary = {}
	
	for i in get_used_cells():
		cells[i] = {
			tile_idx = get_cell(i.x, i.y),
			flip_x = is_cell_x_flipped(i.x, i.y),
			flip_y = is_cell_y_flipped(i.x, i.y),
			transposed = is_cell_transposed(i.x, i.y),
			autotile = get_cell_autotile_coord(i.x, i.y)
			}
	
	return cells


func get_cell_rect(cell : Vector2) -> Rect2:
	var cell_world : Vector2 = map_to_world(cell)
	return Rect2(cell_world, cell_size)


func get_cell_center(cell : Vector2) -> Vector2:
	var offset : Vector2 = get_cell_size()
	var cell_world : Vector2 = map_to_world(cell)
	
	if not mode == MODE_ISOMETRIC:
		offset.x /= 2
	
	offset.y /= 2
	return cell_world + offset


func get_dirs_as_array() -> PoolVector2Array:
	return Dir.values() as PoolVector2Array


func get_dirs_cardinal() -> Dictionary:
	var dir_cardinal : Dictionary = Dir.duplicate()
	dir_cardinal.erase("UP_LEFT")
	dir_cardinal.erase("UP_RIGHT")
	dir_cardinal.erase("DOWN_LEFT")
	dir_cardinal.erase("DOWN_RIGHT")
	return dir_cardinal


func get_dirs_diagonal() -> Dictionary:
	var dir_diagonals : Dictionary =  Dir.duplicate()
	dir_diagonals.erase("UP")
	dir_diagonals.erase("DOWN")
	dir_diagonals.erase("LEFT")
	dir_diagonals.erase("RIGHT")
	return dir_diagonals


func get_dir_world(dir : Vector2) -> Vector2:
	if not dir in Dir.values():
		return Vector2()
	
	return map_to_world(dir)
