extends "res://src/Test/Physics.gd"



func _draw() -> void:
	draw_circle($Position2D.position, 3, Color.white)


func _process(delta: float) -> void:
	var centered_size : Vector2 = texture.get_size()
	var x : float = sin(displacement) * centered_size.x
	var y : float = abs(cos(displacement)) * centered_size.y - (centered_size.y / 2)
	
	$Position2D.position = Vector2(x, y)
	set_displacement(displacement + delta)
	update()
