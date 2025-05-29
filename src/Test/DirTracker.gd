extends Node2D

var dir : Vector2 = Vector2()



func _process(delta: float) -> void:
	look_at(global_position + dir)
