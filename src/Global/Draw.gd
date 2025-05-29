extends Object
class_name Draw

enum DrawType {POLYLINE, POLY_PATTERN, CIRCLE, RECT, POLYGON}

var rotation : Dictionary = {
	speed_max = 0.0,
	speed_current = 0.0,
	time_max = 0.0,
	time_current = 0.0,
	start_at_max_speed = false
}
var blink : Dictionary = {
	speed_max = 0.0,
	speed_current = 0.0,
	time_max = 0.0,
	time_current = 0.0,
	fade = false
}
var grow : Dictionary = {
	speed_max = 0.0,
	speed_current = 0.0,
	time_max = 0.0,
	time_current = 0.0,
	size_max = 0.0,
	size_current = 0.0
}
var _vector_draw : Array = []
var _parent_rid : RID setget set_parent_rid
var _rid : RID = VisualServer.canvas_item_create()
var _started : bool = false



func _apply_rotation() -> void:
	for i in _vector_draw:
		for j in i.draw_array.size():
			i.draw_array[j] = i.draw_array[j].rotated(rotation.speed_current)
	
	rotation.speed_current = lerp(rotation.speed_current, rotation.speed_max, 0.02)
	print(rotation.speed_current)


func _apply_growth() -> void:
	return


func _apply_blink() -> void:
	return



func add_circle(radius : float, color : Color, filled : bool = true, segements : int = 1) -> void:
	_vector_draw.append({
		draw_type = DrawType.CIRCLE,
		radius = radius,
		color = color,
		filled = filled,
		segements = segements
	})


func add_polygon() -> void:
	return


func add_polyline_pattern(points : PoolVector2Array, color : Color, times_to_repeat : int, wrap_around : bool = false, wrap_radius : float = 5.0) -> void:
	_vector_draw.append({
		draw_type = DrawType.POLY_PATTERN,
		color = color,
		times_to_repeat = times_to_repeat,
		wrap_around = wrap_around,
		wrap_radius = wrap_radius
	})
#	for i in range(1, times_to_repeat + 1):
#		for j in points.size():
#			points[j] *= i
#
#		VisualServer.canvas_item_add_polyline(_rid, points, [color], 2.0, true)


func add_rect() -> void:
	return


func add_polyline(type : int, array_to_draw : Array) -> void:
	_vector_draw.append({
		draw_type = type,
		draw_array = array_to_draw
	})


func clear() -> void:
	_vector_draw.clear()


func update(delta : float) -> void:
	VisualServer.canvas_item_clear(_rid)
#	_apply_rotation()
	
#	for i in _vector_draw:
#		VisualServer.canvas_item_add_polyline(_rid, i.draw_array, [Color.white], 2.0, true)
#
#	rotation.time_current += delta
#	blink.time_current += delta
#	grow.time_current += delta



func set_parent_rid(new_rid : RID) -> void:
	_parent_rid = new_rid
	VisualServer.canvas_item_set_parent(_rid, _parent_rid)
