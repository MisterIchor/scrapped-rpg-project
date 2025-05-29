tool
extends "res://src/Modes/Encounter/Tactical/Map/MasterMap.gd"

var map_name : String = "NewMap"
var _tilemaps : Array = []
var _should_delete : bool = false
var draw_navigation : bool = false
var selected_tilemap : String = String()
var connected_paths : Array = []
#var astar_point_precision : int = 32



func _ready() -> void:
	_manage_tilemaps()
	yield(get_tree(), "idle_frame")
	
#	if not Engine.editor_hint:
#		generate_navigation()
#	update()


func _process(_delta: float) -> void:
	_manage_tilemaps()
	
	# TileMap uses set_cell to delete tiles, but since there are no tiles to delete
	# on the main tileset, it won't work to remove cells from the other _tilemaps. 
	# A solution like the one below has to be made.
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT) and _should_delete:
		# Editor only uses set_cell, not set_cellv, so we have to convert the
		# global mouse pos to map pos.
		var pos : Vector2 = world_to_map(get_global_mouse_position())
		get_node(selected_tilemap).set_cell(pos.x, pos.y, -1)
	
	if Input.is_mouse_button_pressed(BUTTON_XBUTTON2) or Input.is_key_pressed(KEY_KP_1):
		_should_delete = true
	elif Input.is_mouse_button_pressed(BUTTON_XBUTTON1) or Input.is_key_pressed(KEY_KP_2):
		_should_delete = false


func _draw() -> void:
	var board_rid : RID
	
	if get_children().empty():
		board_rid = get_canvas_item()
	else:
		board_rid = get_child(current_floor).get_canvas_item()
	
	VisualServer.canvas_item_clear(board_rid)
	
	if draw_navigation:
		for i in waypoints:
			if i.z == current_floor:
				VisualServer.canvas_item_add_circle(board_rid, Vector2(i.x, i.y),
						3, Color.white)
	
	var world : Vector2 = map_to_world(map_size)
	var boundaries : Array = [
		Vector2(),
		Vector2(world.x, 0),
		world,
		Vector2(0, world.y),
		Vector2()
	]
	VisualServer.canvas_item_add_polyline(board_rid, boundaries, [Color.white])


func _get_property_list() -> Array:
	var properties : Array = []
	
	properties.append({
		name = "Map Propertes",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_GROUP,
		hint_string = "prop_"
	})
	
	properties.append({
		name = "prop_map_name",
		type = TYPE_STRING
	})
	
	properties.append({
		name = "prop_map_boundaries",
		type = TYPE_VECTOR2
	})
	
	properties.append({
		name = "prop_number_of_floors",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,30,or_greater"
	})
	
	properties.append({
		name = "tilemaps",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = PoolStringArray(_tilemaps).join(",")
	})
	
	properties.append({
		name = "current_floor",
		type = TYPE_INT
	})
	
	properties.append({
		name = "save_map",
		type = TYPE_BOOL
	})
	
	properties.append({
		name = "Navigation Options",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint_string  = "nav_"
	})
	
	properties.append({
		name = "nav_draw_navigation",
		type = TYPE_BOOL
	})
	
	properties.append({
		name = "nav_generate_navigation",
		type = TYPE_BOOL
	})
	
	return properties


func _set(property: String, value) -> bool:
	match property:
		"prop_map_name":
			value = value.capitalize()
			value = value.replacen(" ", "")
			map_name = value
			return true
		"prop_map_boundaries":
			map_size = value
			update()
			return true
		"prop_number_of_floors":
			if not is_inside_tree():
				yield(self, "ready")
			
			set_floors(value)
			return true
		"tilemaps":
			set_selected_tilemap(value)
			return true
		"nav_draw_navigation":
			draw_navigation = value
			update()
			return true
		"nav_generate_navigation":
			if value:
				generate_navigation()
				return true
		"save_map":
			if value:
				var tilemap : TileMap = get_node(selected_tilemap)
				var cell_info : Dictionary = get_used_cells_info()
				
				_set_cells_in_map(tilemap, cell_info)
				file_manager.save_file(map_name)
				tilemap.clear()
				return true
	
	for i in get_children():
		i.set_property_in_tilemaps(property, value)
	
	return false


func _get(property: String):
	match property:
		"prop_map_name":
			return map_name
		"prop_map_boundaries":
			return map_size
		"prop_number_of_floors":
			return floors
		"tilemaps":
			return selected_tilemap
		"nav_draw_navigation":
			return draw_navigation



func _manage_tilemaps() -> void:
	_tilemaps.clear()
	
	for i in get_child(current_floor).get_children():
		_tilemaps.append(i.name)
		i.z_index = i.get_index()
	
	if selected_tilemap.empty():
		selected_tilemap = _tilemaps.front()



func _set_cells_in_map(tilemap : TileMap, cells : Dictionary) -> void:
	if not tilemap:
		return
	
	tilemap.clear()
	
	for i in cells:
		var info : Dictionary = cells[i]
		
		tilemap.set_cell(i.x, i.y, info.tile_idx, info.flip_x, info.flip_y, 
				info.transposed, info.autotile)



func generate_navigation() -> void:
	waypoints.clear()
	
	for i in get_children():
		var obstacle_map : TileMap = i.get_node_or_null("ObstacleMap")
		
		if not obstacle_map:
			LogSystem.write_to_debug(name + ": obstacle map failed to load or isn't assigned. NavGen failed.", 0)
			continue
		
		var boundaries : Rect2 = Rect2(cell_size / 4, map_to_world(map_size) - (cell_size / 4))
		var obstacle_rects : Array = []
		var pos_to_check : Array = get_dirs_as_array()
		
		pos_to_check.append(Vector2())
		
		for cell in obstacle_map.get_used_cells():
			obstacle_rects.append(get_cell_rect(cell).grow(4.0))
		
		for y in range(0, map_size.y):
			for x in range(0, map_size.x):
				for dir in pos_to_check:
					var point_in_pos : Vector2 = get_cell_center(Vector2(x, y)) + (get_dir_world(dir) / 2)
					
					if not boundaries.has_point(point_in_pos):
						continue
					
					var should_add : bool = true
					
					for j in obstacle_rects:
						if j.has_point(point_in_pos):
							should_add = false
							break
					
					if should_add:
						var point_to_add : Vector3 = Vector3(point_in_pos.x, point_in_pos.y, i.get_index())
						waypoints[point_to_add] = calculate_point_index(point_to_add)
	
	for i in waypoints:
		if i.z == 0:
			print(i)
	
	update()




func calculate_point_index(point : Vector3) -> float:
	return (point.x + map_size.x * point.y * map_size.y) * (point.z + 1)



func set_floors(new_amount : int) -> void:
	.set_floors(new_amount)
	
	for i in get_children():
		i.owner = self


func set_map(path_to : String) -> void:
	var current_map : String = map
	.set_map(path_to)
	
#	if not map == current_map:
#		set_map_name(map.get_basename().get_file())



func set_selected_tilemap(tilemap : String) -> void:
	return
	var new_tilemap : TileMap = get_child(current_floor).get_node_or_null(tilemap)
	
	if not new_tilemap:
		LogSystem.write_to_debug(name + ": tilemap of name " + tilemap + " does not exist.", 0)
		return
	
	var prev_tilemap : TileMap = get_child(current_floor).get_node(selected_tilemap)
	
	_set_cells_in_map(prev_tilemap, get_used_cells_info())
	_set_cells_in_map(get_node("."), new_tilemap.get_used_cells_info())
	new_tilemap.clear()
	z_index = new_tilemap.get_index()
	set_tileset(new_tilemap.get_tileset())
	property_list_changed_notify()
	selected_tilemap = tilemap


#func set_cell(x : int, y : int, tile : int, flip_x : bool = false, flip_y : bool = false, transpose : bool = false, autotile_coord : Vector2 = Vector2( 0, 0 )) -> void:
#	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
#	_set_cells_in_map(get_node(selected_tilemap), get_used_cells())
#	clear()



func get_map_name() -> String:
	var formatted_name : String = map_name
	
	formatted_name = formatted_name.capitalize()
	return formatted_name
