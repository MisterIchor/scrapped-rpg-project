extends Node2D

enum DrawTypes {PATH, AURA, POINT}

onready var tactical_map : Node2D = get_node("../TacticalMap")

var _should_draw : bool = false setget set_draw
var draw : Array = []



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update()


func _draw() -> void:
	return
	for i in tactical_map.waypoints:
		draw_circle(i, 1, Color.white)
#	if not _should_draw:
#		return
#
#	for i in draw:
#		match i.type:
#			DrawTypes.PATH:
#				return
#
#			DrawTypes.AURA:
#				return
#
#			DrawTypes.POINT:
#				return



func add_draw(type : int, vec2_array : PoolVector2Array) -> void:
	if not type in DrawTypes.values():
		return
	
	draw.append({
		draw_type = type,
		points = vec2_array,
	})
	update()



func set_draw(value : bool) -> void:
	_should_draw = value
	set_process(_should_draw)
	update()


