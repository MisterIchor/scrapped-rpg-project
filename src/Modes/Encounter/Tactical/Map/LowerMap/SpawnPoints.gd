tool
extends "../GlobalMap.gd"

var spawn : Dictionary = {
	party = [],
	ally = [],
	enemy = [],
	neutral = [],
}



func _enter_tree() -> void:
	if not Engine.editor_hint:
		hide()
		prepare_spawn_points()



func add_world_spawn_points(type : String, spawn_points : Array) -> void:
	if spawn.has(type):
		for i in spawn_points:
			spawn[type].append(i)


func add_mapped_spawn_points(type : String, spawn_points : Array) -> void:
	var world_list : Array = convert_mapped_points_to_world(spawn_points)

	add_world_spawn_points(type, world_list)


func convert_mapped_points_to_world(spawn_points : Array) -> Array:
	var converted_spawn_points : Array = []

	for i in spawn_points:
		var point : Vector2 = map_to_world(i)

		point = get_cell_center(point)
		converted_spawn_points.append(point)

	return converted_spawn_points


func clear_spawn_points(type : String) -> void:
	if spawn.has(type):
		spawn[type].clear()
		LogSystem.write_to_debug(str("SpawnMap: Cleared spawn points of type ", type), 2)
	else:
		LogSystem.write_to_debug(str("SpawnMap: Attempt to clear spawn points of non-existant type ", type), 0)


func purge_all_spawn_points() -> void:
	for i in spawn:
		clear_spawn_points(i)


func prepare_spawn_points() -> void:
	purge_all_spawn_points()
	add_mapped_spawn_points("party", get_used_cells_by_id(0))



func get_spawn_points() -> Dictionary:
	return spawn
