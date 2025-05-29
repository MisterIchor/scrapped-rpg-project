tool
extends Node2D

var start_pos : Dictionary = {}
var max_length : Dictionary = {}



func _ready() -> void:
	for i in get_children():
		start_pos[i] = i.global_position
	
	max_length[$Position2D] = $Position2D2.global_position.distance_to($Position2D.global_position)
	update()



func _draw() -> void:
	var line : Array = []
	
	for i in get_children():
		line.append(i.get_global_position())
	
	for i in line:
		draw_circle(i, 2, Color.orange)
	
	draw_polyline(line, Color.blue)



func _process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	var offset : Vector2 = get_global_mouse_position() - start_pos[$Position2D2]
	
	$Position2D.global_position = start_pos[$Position2D2] + (offset.normalized() * max_length[$Position2D])
	update()
	
