tool
extends TileSet
class_name TileSetTactical

export (Array, Resource) var tiles : Array setget set_tiles
# The tile that will be used to fill any empty cells on the ground floor as well
# as the void outside the map's boundaries.
# If a ground tile on the ground floor is destroyed, it will be replaced with
# the default ground tile.
# Default ground tiles cannot be destroyed.
export (int) var default_ground_tile_index : int = 0



func set_tiles(new_tiles : Array) -> void:
	tiles = new_tiles
	
	if not Engine.editor_hint:
		return
	
	print("E")
	
	if tiles.empty():
		clear()
	
	for i in range(tiles.size()):
		var tile : TileTemplate = tiles[i]
		
		if not tile:
			var used_ids : Array = get_tiles_ids()
			
			if i in used_ids:
				remove_tile(i)
			
			continue
		
		create_tile(i)
		tile_set_name(i, tile.name)
		tile_set_texture(i, tile.sprite)
