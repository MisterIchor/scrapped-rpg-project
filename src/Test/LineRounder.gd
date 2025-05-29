extends Node2D

var line : PoolVector2Array = [Vector2(400, 400), Vector2(425, 500), Vector2(400, 600)]
export (PoolVector2Array) var line2 : PoolVector2Array = [Vector2(300, 100), Vector2(300, 300)]
export (int, 1, 10) var subdivision : int = 1
export (int, 0, 999) var offset : int = 50


func _ready() -> void:
	var direction : Vector2 = line2[0].direction_to(line2[1])
	var length : float = line2[0].length()
	var distance : Vector2 = (line2[1] - line2[0]) / (subdivision)
	var start : Vector2 = line2[0]
	var middle : int = 0
	
	line2.invert()
	
	for i in range(1, subdivision):
		line2.insert(1, (distance * i) + start)
	
	line2.invert()
	middle = line2.size() / 2
	
	if line2.size() % 2 == 1:
		line2[middle] += Vector2(offset / (middle + 1), 0)
	
	for i in range(middle, 0, -1):
		var current_offset : int = offset / i
		
		line2[i - 1] += Vector2(current_offset, 0)
		line2[-i] += Vector2(current_offset, 0)



func _draw() -> void:
#	for i in line:
#		draw_circle(i, 5, Color.blue)
#
	for i in line2:
		draw_circle(i, 2, Color.green)
	
	draw_polyline(line2, Color.red)
	draw_polyline(line, Color.orange)


func _process(delta: float) -> void:
	update()
