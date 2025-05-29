tool
extends "res://src/Modes/Encounter/Tactical/Map/GlobalMap.gd"

export (String, "PICK_ONE", "SAVE_MAP", "LOAD_MAP", "CLEAR_MAP") var map_options : String
export (Vector2) var map_size : Vector2 = Vector2(32, 32) setget set_map_size
var tilemaps : Array = []
var selected_tilemap : String = String()
var should_delete : bool = false
var waypoints : Array = []
var connected_paths : Array = []

var navigation : Navigation2D = preload("res://src/Test/TacticalMapTest/Navigation.gd").new()
onready var astar : AStar2D = AStar2D.new()

signal path_sent(node, path)



func _enter_tree() -> void:
	if not Engine.editor_hint:
		add_child(navigation, true)


func _ready() -> void:
	if Engine.editor_hint:
		_manage_tilemaps()


func _draw() -> void:
	if Engine.editor_hint:
		var lines_to_draw : Array = [
			Vector2(0, 0),
			map_to_world(Vector2(map_size.x, 0)),
			map_to_world(map_size),
			map_to_world(Vector2(0, map_size.y)),
			Vector2(0, 0)
		]
		draw_polyline(lines_to_draw, Color(1,1,1))


func _set(property: String, value) -> bool:
	if property.match("TileMaps") and typeof(value) == TYPE_STRING:
		selected_tilemap = value
		set_tileset(get_node(selected_tilemap).get_tileset())
		return true
	
	for i in get_children():
		i.set(property, value)
	
	return false


func _get(property: String):
	if property == "TileMaps":
		return tilemaps


func _get_property_list() -> Array:
	var properties : Array = []
	
	properties.append({
		name = "TileMaps",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = PoolStringArray(tilemaps).join(",")
	})
	
	return properties


func _process(delta: float) -> void:
	if not Engine.editor_hint:
		return
	
	_manage_tilemaps()
	
	# TileMap uses set_cell to delete tiles, but since there are no tiles to delete
	# on the main tileset, it won't work to remove cells from the other tilemaps. 
	# A solution like the one below has to be made.
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT) and should_delete:
		# Editor only uses set_cell, not set_cellv, so we have to convert the
		# global mouse pos to map pos.
		var pos : Vector2 = world_to_map(get_global_mouse_position())
		get_node(selected_tilemap).set_cell(pos.x, pos.y, -1)
	
	if Input.is_mouse_button_pressed(BUTTON_XBUTTON2) or Input.is_key_pressed(KEY_KP_1):
		should_delete = true
	elif Input.is_mouse_button_pressed(BUTTON_XBUTTON1) or Input.is_key_pressed(KEY_KP_2):
		should_delete = false



func _manage_tilemaps() -> void:
	for i in get_children():
		if i is TileMap:
			var map_name : String = i.get_name()
			
			if tilemaps.find(map_name) == -1:
				tilemaps.append(map_name)
	
	for i in tilemaps:
		if get_node_or_null(i) == null:
			tilemaps.erase(i)
	
	if selected_tilemap.empty():
		selected_tilemap = tilemaps.front()


func _save_map() -> void:
	return


func _load_map() -> void:
	return



func _set_cells_in_map(tilemap : TileMap, cells : Array) -> void:
	var tile_idx : PoolIntArray = []
	var flip_x : Array = []
	var flip_y : Array = []
	var transpose : Array = []
	var autotile : PoolVector2Array = []
	
	for i in cells:
		tile_idx.append(get_cell(i.x, i.y))
		flip_x.append(is_cell_x_flipped(i.x, i.y))
		flip_y.append(is_cell_y_flipped(i.x, i.y))
		transpose.append(is_cell_transposed(i.x, i.y))
		autotile.append(get_cell_autotile_coord(i.x, i.y))
	
	for i in range(cells.size()):
		tilemap.set_cell(cells[i].x, cells[i].y, tile_idx[i], flip_x[i], 
				flip_y[i], transpose[i], autotile[i])



func get_cell_points(cell : Vector2) -> PoolVector2Array:
	var cell_world_pos : Vector2 = map_to_world(cell)
	return PoolVector2Array([
		cell_world_pos,
		cell_world_pos + Vector2(cell_size.x, 0),
		cell_world_pos + cell_size,
		cell_world_pos + Vector2(0, cell_size.y)
	])


func calculate_point_index(point : Vector2) -> float:
	return point.x + map_size.x * point.y * map_size.y



func set_map_size(new_size : Vector2) -> void:
	map_size = new_size
	update()


func set_selected_tilemap(new_type : String) -> void:
	selected_tilemap = new_type
	
	if get_node_or_null(selected_tilemap) == null:
		LogSystem.write_to_debug(name + ": tilemap of name " + selected_tilemap + " does not exist.", 0)
		return
	
	set_tileset(get_node(selected_tilemap).get_tileset())
	property_list_changed_notify()


func set_cell(x : int, y : int, tile : int, flip_x : bool = false, flip_y : bool = false, transpose : bool = false, autotile_coord : Vector2 = Vector2( 0, 0 )) -> void:
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	_set_cells_in_map(get_node(selected_tilemap), get_used_cells())
	clear()



func get_walkable_path(point_one : Vector2, point_two : Vector2) -> PoolVector2Array:
	var point_one_index : int = astar.get_closest_point(point_one)
	var point_two_index : int = astar.get_closest_point(point_two)
	
	if point_one_index in astar.get_points() and point_two_index in astar.get_points():
		var path : PoolVector2Array = astar.get_point_path(point_one_index, point_two_index)
		
		path[0] = point_one
		return path
	
	return PoolVector2Array()


func get_tiles_in_cell(cell_pos : Vector2) -> Dictionary:
	var tiles : Dictionary = {}
	
	for i in tilemaps:
		var tilemap : TileMap = get_node(i)
		var tile_idx : int = tilemap.get_cell(cell_pos.x, cell_pos.y)
		
		if not tile_idx == INVALID_CELL:
			var tileset : TileSet = tilemap.get_tileset()
			tiles[i] = tileset.tile_get_name(tile_idx)
	
	return tiles



func _on_path_requested(node : Node, point_one : Vector2, point_two : Vector2) -> void:
	emit_signal("path_sent", node, get_walkable_path(point_one, point_two))
