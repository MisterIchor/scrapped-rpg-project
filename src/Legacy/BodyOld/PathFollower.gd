extends PathFollow2D

onready var direction_tracker : Node = ($DirectionHelper as Node)
onready var sprite : Sprite = ($SpriteBody as Sprite)
onready var state_machine : Node = ($StateMachine as Node)




func set_sprite(x_offset : int, y_offset : int) -> void:
	sprite.set_offset(Vector2(x_offset, y_offset))



func get_angle_to_mouse() -> float:
	var angle : float = global_position.angle_to_point(get_global_mouse_position())
	
	angle = rad2deg(angle)
	return angle
