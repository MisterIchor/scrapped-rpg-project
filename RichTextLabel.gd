extends Node2D

var draw = Draw.new()
var test = load("res://src/Resources/Actions/CautiousApproach.tres")



func _init() -> void:
	draw.set_parent_rid(get_canvas_item())
	draw.add_polyline_pattern([], Color.white, 1)
	


func _process(delta: float) -> void:
	draw.update(delta)
