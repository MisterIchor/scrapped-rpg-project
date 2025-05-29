extends Control

var dir : int = 0



func _process(delta):
	return
	if $Camera2D.zoom >= Vector2(1.5, 1.5):
		dir = 1
	elif $Camera2D.zoom <= Vector2(0.5, 0.5):
		dir = 0
	
	match dir:
		0:
			$Camera2D.zoom += Vector2(0.01, 0.01)
		1:
			$Camera2D.zoom -= Vector2(0.01, 0.01)
	
	material.set_shader_param("zoom_scale", $Camera2D.zoom.x)
