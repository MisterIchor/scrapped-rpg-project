tool
extends "../MasterMap.gd"

#onready var ground_map : TileMap = ($GroundMap as TileMap)
#onready var spawn_map : TileMap = ($SpawnMap as TileMap)
#onready var obstacle_map : TileMap = ($ObstacleMap as TileMap)



#func _ready() -> void:
#	set_floors(1)
#	if not Engine.editor_hint:
#		spawn_map.hide()
#
#		for i in obstacle_map.get_used_cells():
#			var wall : BaseBody = preload("res://src/Entities/BaseBody.tscn").instance()
#
##			wall.set_script(preload("res://src/Test/Wall.gd"))
#			wall.global_position = map_to_world(i)
#			add_child(wall)
#
#
#
#func query_obstacles() -> Dictionary:
#	return {}



#func get_ground_tiles() -> Array:
#	return ground_map.get_used_cells()
#
#
#func get_obstacles() -> Array:
#	return obstacle_map.get_list_of_obstacles_world()
#
#
#func get_spawn_points() -> Array:
#	var spawn_points : Array = []
#
#	for i in spawn_map.get_used_cells():
#		spawn_points.append(get_cell_center(i))
#
#	return spawn_points
