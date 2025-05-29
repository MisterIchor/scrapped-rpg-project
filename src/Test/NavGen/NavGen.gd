extends Node

func _ready() -> void:
	print(OS.get_ticks_msec())
	$TileMap.generate_navigation($TileMap/ObstacleMap.get_used_cells())
	print(OS.get_ticks_msec())
