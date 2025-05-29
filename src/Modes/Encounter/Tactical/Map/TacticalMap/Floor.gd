tool
extends Node2D

signal tilemap_added(tilemap)
signal height_updated(new_height)

const DEFAULT_FLOOR_HEIGHT : int = 300

export (float) var height : float = DEFAULT_FLOOR_HEIGHT



func add_tilemap(map_name : String, script : GDScript) -> TileMap:
	if get_node_or_null(map_name):
		return (get_node(map_name) as TileMap)
	
	var new_tilemap : TileMap = TileMap.new()
	new_tilemap.set_script(script)
	
	if get_child_count():
		new_tilemap.mode = get_child(0).mode
		new_tilemap.cell_size = get_child(0).cell_size
	
	new_tilemap.name = map_name
	add_child(new_tilemap)
	new_tilemap.owner = self
	return new_tilemap



func set_property_in_tilemaps(property_name : String, value) -> void:
	for i in get_children():
		i.set(property_name, value)


func set_cell_in_tilemap(cell_info : Array, tilemap : TileMap) -> void:
	return



func get_tiles_in_cell(cell_pos : Vector2) -> Dictionary:
	var tiles : Dictionary = {}
	
	for i in get_children():
		var tile_idx : int = i.get_cell(cell_pos.x, cell_pos.y)
		
		if not tile_idx == TileMap.INVALID_CELL:
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


func get_tilemap(tilemap_name : String) -> TileMap:
	return get_node_or_null(tilemap_name) as TileMap
