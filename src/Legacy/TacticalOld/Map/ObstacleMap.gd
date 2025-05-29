tool
extends "LowerMap.gd"

var character_positions : Dictionary = {}



func is_obstacle_at_mapped(pos : Vector2) -> bool:
	return true if not get_cell(pos.x, pos.y) == -1 else false


func is_obstacle_at_world(pos : Vector2) -> bool:
	return true if not get_cellv(pos) == -1 else false


func update_character_position(character : Node, new_position : Vector2) -> void:
	if character_positions.has(character):
		set_cellv(character_positions[character], -1)
	
	character_positions[character] = new_position
	set_cellv(character_positions[character], 0)



func get_list_of_obstacles_world() -> Array:
	var obstacles : Array = get_used_cells()
	var obstacles_world : Array = []
	
	for i in obstacles:
		obstacles_world.append(get_center_of_tile(map_to_world(i)))
	
	return obstacles_world


func get_list_of_obstacles_mapped() -> Array:
	return get_used_cells()
