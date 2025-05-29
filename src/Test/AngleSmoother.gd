tool
extends Node2D

export (PoolVector2Array) var line : PoolVector2Array = [Vector2(100, 100), Vector2(300, 200), Vector2(400, 400)]
export (int, 0, 100) var iterations : int = 0
export (float, 0, 1) var point_exponent : float = 0.5


func _ready() -> void:
#	var segment_one_midpoint : Vector2 = (line[1] - line[0]) * point_exponent + line[0]
#	var segment_two_midpoint : Vector2 = (line[2] - line[1]) * (1 - point_exponent) + line[1]
	if Engine.editor_hint:
		return
	
	for i in range(iterations):
		var new_line : Array = []
		var points_to_remove : PoolVector2Array = []
		var invert : bool = false
		
		for j in range(1, line.size()):
			var point : Dictionary = {
			start = line[j - 1],
			end = line[j],
		}
			new_line.append(point.start)
			new_line.append(get_midpoint(point.start, point.end))
			points_to_remove.append(point.end)
		
		for j in points_to_remove:
			if j in new_line:
				new_line.erase(j)
		
#		if line[0] == line[line.size() - 1]:
#			new_line[0] = line[0] / 2
#			new_line[-1] = line[-1] / 2
		
		new_line.append(line[line.size() - 1])
		line = new_line



func get_midpoint(point_one : Vector2, point_two : Vector2) -> Vector2:
	return (point_two - point_one) * 0.5 + point_one



func _draw() -> void:
#	for i in line:
#		draw_circle(i, 2, Color.orange)
	
	if not line.size() > 1:
		return
	
	draw_polyline(line, Color.yellow)


func _process(delta: float) -> void:
	update()
