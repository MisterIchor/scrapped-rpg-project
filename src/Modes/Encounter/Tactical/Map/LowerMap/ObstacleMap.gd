tool
extends "../GlobalMap.gd"

#var walls : Dictionary = {}



func _ready() -> void:
	if Engine.editor_hint:
		return
	
	for i in tile_set.get_tiles_ids():
		var tiles : Array = get_used_cells_by_id(i)
		
		if tiles.empty():
			continue
		
		for j in tiles:
			var wall : BaseBody = create_wall(tile_set.tiles[i])
			wall.global_position = map_to_world(j) + (cell_size / 2)
			add_child(wall)
			
			if wall.height == -1:
				wall.height = get_parent().height
	
	clear()



func create_wall(template : TileWallTemplate) -> BaseBody:
#	var new_body : TileWallBody = template.create_body()
#	var template_container : TemplateContainer = TemplateContainer.new()
#
#	template_container.set_template(template)
#	new_body.set_container(template_container)
	return BaseBody.new()


func is_obstacle_at_mapped(pos : Vector2) -> bool:
	return not get_cell(pos.x, pos.y) == -1


func is_obstacle_at_world(pos : Vector2) -> bool:
	return not get_cellv(world_to_map(pos)) == -1


#func update_character_position(character : Node, new_position : Vector2) -> void:
#	if character_positions.has(character):
#		var old_pos : Vector2 = world_to_map(character_positions[character])
#		set_cell(old_pos.x, old_pos.y, -1)
#
#	character_positions[character] = new_position
#
#	var mapped_pos : Vector2 = world_to_map(character_positions[character])
#	set_cell(mapped_pos.x, mapped_pos.y, 0)



#func get_character_positions() -> Dictionary:
#	return character_positions


func get_list_of_obstacles_world() -> Array:
	var obstacles : Array = get_used_cells()
	var obstacles_world : Array = []

	for i in obstacles:
		obstacles_world.append(get_cell_center(i))

	return obstacles_world


func get_list_of_obstacles_mapped() -> Array:
	return get_used_cells()
