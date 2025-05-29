extends Node2D

func _draw():
	draw_line($Position2D.global_position, $Position2D2.global_position, Color(1,1,1,1))

func _input(event):
	if event.is_action_pressed("leftmouse"):
		update()