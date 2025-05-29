extends Node

onready var tilemap : TileMap = ($TravelMap as TileMap)
onready var arrow : KinematicBody2D = ($TravelArrow as KinematicBody2D)
onready var arrowpos : Position2D = ($TravelArrow/Position2D as Position2D)



func _enter_tree() -> void:
	MusicSystem.set_music_folder("res://assets/music/travel/")


func _on_TravelArrow_moving():
	var terrain = ""
	
	terrain = str(tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(arrowpos.global_position))))
	
	if terrain == "":
		arrow.speed = 50.0
	else:
		match terrain:
			'GrassyPlains', 'WoodsEndBottom', 'WoodsEndBottomLeft', 'WoodsEndBottomRight', 'WoodsEndLeft', 'WoodsEndRight', 'WoodsEndTop','WoodsEndTopLeft', 'WoodsEndTopRight':
				arrow.speed = 50.0
			'WoodsMiddle':
				arrow.speed = 30.0
			'Hills':
				arrow.speed = 30.0
			'Mountains':
				arrow.speed = 5.0
			'Road', 'RoadTurn':
				arrow.speed = 65.0
			'Sand':
				arrow.speed = 45.0
			'Snow':
				arrow.speed = 40.0
			'Swamp':
				arrow.speed = 35.0
			'SwampWater':
				arrow.speed = 15.0
			'Water':
				arrow.speed = 20.0
