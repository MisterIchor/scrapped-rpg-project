tool
extends "GlobalMap.gd"

const Floor : PackedScene = preload("res://src/Modes/Encounter/Tactical/Map/TacticalMap/Floor.tscn")

signal map_loaded

export (String, FILE, GLOBAL, "*.map") var map : String  setget set_map

var map_size : Vector2 = Vector2(32, 32)
var file_manager : FileManager = FileManager.new()
var waypoints : Dictionary = {}
var astar : AStar = preload("res://src/Modes/Encounter/Tactical/Map/TacticalMap/Navigation.gd").new()
var floors : int = 0 setget set_floors
var current_floor : int = 0 setget set_current_floor


func _init() -> void:
	file_manager.set_owner(self)
	file_manager.object_to_manage = self
	file_manager.file_type = ".map"
	file_manager.folder_path = "res://assets/saved/maps"
#	file_manager.add_value_to_manage("floors", "set_floors")
	file_manager.add_value_to_manage("waypoints", "initialize_navigation")
	file_manager.add_value_to_manage("tilemaps_info", "initialize_tilemaps", "get_tilemaps_info")
	file_manager.add_value_to_manage("map_size")



func add_floor() -> void:
	add_child(Floor.instance())


func add_tilemap(map_name : String) -> TileMap:
	if get_node_or_null(map_name):
		return (get_node(map_name) as TileMap)
	
	var new_tilemap : TileMap = TileMap.new()
	
	new_tilemap.mode = mode
	new_tilemap.cell_size = cell_size
	new_tilemap.name = map_name
	add_child(new_tilemap)
	new_tilemap.owner = self
	return new_tilemap


func initialize_tilemaps(tilemaps_info : Dictionary) -> void:
	for i in tilemaps_info:
		var tilemap : TileMap = get_node_or_null(i)
		
		if not tilemap:
			tilemap = add_tilemap(i)
		else:
			tilemap.clear()
		
		if tilemaps_info[i].tilemap_script:
			tilemap.set_script(load(tilemaps_info[i].tilemap_script))
		
		if tilemaps_info[i].tileset:
			tilemap.tile_set = load(tilemaps_info[i].tileset)
		
		var cells : Dictionary = tilemaps_info[i].cells
		
		for j in cells:
			var info : Dictionary = cells[j]
			
			tilemap.set_cell(j.x, j.y, info.tile_idx, info.flip_x, 
					info.flip_y, info.transposed, info.autotile)
	
	if Engine.editor_hint:
		update()


func initialize_navigation(points : Dictionary) -> void:
	return
#	astar.clear()
#
#	for i in points:
#		astar.add_point(points[i], i)
#
#	for i in points:
#		var point_idx : int = points[i]
#
#		for j in get_dirs_as_array():
#			var point_dir_idx : int = points.get(i + (j * (cell_size / 2)), INVALID_CELL)
#
#			if not point_dir_idx == INVALID_CELL:
#				astar.connect_points(point_idx, point_dir_idx)
##				connected_paths.append([point, point_dir])
#
#	LogSystem.write_to_debug("TacticalMap: Waypoints connected.", 3)



func set_floors(new_amount : int) -> void:
	if new_amount > 30 or new_amount == floors:
		return
	
	var difference : int = floors - new_amount
	
	for i in abs(difference):
		match sign(difference):
			-1.0:
				add_floor()
			1.0:
				get_child(get_child_count() - 1).free()
	
	floors = new_amount


func set_current_floor(new_floor : int) -> void:
	current_floor = clamp(new_floor, 0, floors)
	
	for i in get_children():
		if not i.get_index() == current_floor:
			i.hide()
		else:
			i.show()


func set_map(path_to : String) -> void:
	if path_to.matchn(map):
		return
	
	if get_children().empty():
		yield(self, "ready")
	
	if path_to == map:
		return
	
	map = path_to
	
	if not map.empty():
		file_manager.load_file(map.get_file())
		emit_signal("map_loaded")



func get_current_floor_node() -> Node2D:
	return get_child(current_floor) as Node2D


func get_map_size_world() -> Vector2:
	return map_to_world(map_size)


func get_tiles_in_cell(cell_pos : Vector2) -> Dictionary:
	var tiles : Dictionary = {}
	
	for i in get_children():
		var tile_idx : int = i.get_cell(cell_pos.x, cell_pos.y)
		
		if not tile_idx == INVALID_CELL:
			var tileset : TileSet = i.get_tileset()
			tiles[i] = tileset.tile_get_name(tile_idx)
	
	return tiles


func get_tilemaps_info() -> Dictionary:
	var tilemaps_info : Dictionary = {}
	
	for i in get_children():
		tilemaps_info[i.name] = {
			tilemap_script = null,
			tileset = String(),
			cells = i.get_used_cells_info()
		}
		
		if i.get_script():
			tilemaps_info[i.name].tilemap_script = i.get_script().resource_path
		
		if i.tile_set:
			tilemaps_info[i.name].tileset = i.tile_set.resource_path
	
	return tilemaps_info
