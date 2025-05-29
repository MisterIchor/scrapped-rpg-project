extends Sprite

var displacement : Vector2 = Vector2() setget set_displacement



func _init() -> void:
	material = ShaderMaterial.new()
	material.shader = preload("res://src/Test/sway.shader")



func set_displacement(new_displacement : Vector2) -> void:
	displacement.x = clamp(new_displacement.x, -1.0, 1.0)
	displacement.y = clamp(new_displacement.y, -1.0, 1.0)
	
	var texture_size : Vector2 = texture.get_size()
	material.set_shader_param("displacement_x", texture_size.x * displacement.x)
	material.set_shader_param("displacement_y", texture_size.y * displacement.y)
