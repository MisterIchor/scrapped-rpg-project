extends PathFollow2D

onready var sprite : Sprite = ($SpriteBody as Sprite)

signal point_reached(new_position)



func _enter_tree() -> void:
	connect("point_reached", self, "_on_point_reached")



func set_sprite(x_offset : int, y_offset : int) -> void:
	sprite.set_offset(Vector2(x_offset, y_offset))


func set_sprite_facing() -> void:
	return



func get_angle_to_mouse() -> float:
	var angle : float = global_position.angle_to_point(get_global_mouse_position())
	
	angle = rad2deg(angle)
	return angle



func _on_point_reached() -> void:
	offset = 0
	set_global_position(get_global_position().round())
