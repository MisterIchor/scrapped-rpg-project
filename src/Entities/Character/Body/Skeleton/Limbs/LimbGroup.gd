extends Node2D



func _ready() -> void:
	for i in get_children():
		i.get_front_section().set_sprite_texture(load("res://assets/graphics/limbs/circle.png"))
		i.get_front_section().length.size = 8



func play_animation_on_all(animation, delay : float) -> void:
	return


