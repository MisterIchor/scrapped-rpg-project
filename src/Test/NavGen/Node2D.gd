extends Node2D



func _ready() -> void:
	yield(get_tree(), "idle_frame")
	update()



#func _draw() -> void:
#	var navigation : Node = get_node("../TileMap")
#	for i in navigation.navigation:
#		var point_info : Dictionary = navigation.navigation[i]
#
#		draw_circle(i, 5, Color.white)
#
#		for j in point_info.adjacent:
#			draw_line(i, j, Color.gray)
