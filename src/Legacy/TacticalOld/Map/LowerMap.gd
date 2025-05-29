extends "TileMap.gd"



func _on_TacticalMap_settings_changed(cell_size : Vector2) -> void:
	set_cell_size(cell_size)
	print("cool")
