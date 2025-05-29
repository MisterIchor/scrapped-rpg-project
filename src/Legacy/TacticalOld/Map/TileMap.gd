extends TileMap

var Directions : Dictionary = {
	UP_RIGHT = get_cell_size() * Vector2(1, -1) / 2,
	UP = get_cell_size() * Vector2(0, -1),
	UP_LEFT = get_cell_size() * Vector2(-1, -1) / 2,
	LEFT = get_cell_size() * Vector2(-1, 0),
	DOWN_LEFT = get_cell_size() * Vector2(-1, 1) / 2,
	DOWN = get_cell_size() * Vector2(0, 1),
	DOWN_RIGHT = get_cell_size() / 2,
	RIGHT = get_cell_size() * Vector2(1, 0),
}



func get_center_of_tile(tile : Vector2) -> Vector2:
	return map_to_world(world_to_map(tile)) + Vector2(0, get_cell_size().y / 2)


func get_directions() -> Dictionary:
	return Directions
