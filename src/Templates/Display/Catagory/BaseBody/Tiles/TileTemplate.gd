tool
extends BaseBodyTemplate
class_name TileTemplate

# If unchecked, will skip the creation of a BaseBody when creating this tile.
export (bool) var has_collision : bool = true
export (Texture) var destroyed_sprite : Texture = null


func _init() -> void:
	add_bank("footstep")



func create_body() -> BaseBody:
	if not has_collision:
		return null
	
	return .create_body()
