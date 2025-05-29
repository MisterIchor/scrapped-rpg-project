extends AStar

var scaled_points : Dictionary = {}



func add_point(id : int, point : Vector3, weight_scale : float = 1.0) -> void:
	.add_point(id, point, weight_scale)
	
	if not weight_scale == 1.0:
		scaled_points[id] = weight_scale
	else:
		scaled_points.erase(id)


func reset_weight_scales() -> void:
	while not scaled_points.empty():
		set_point_weight_scale(scaled_points.keys()[0], 1.0)



func set_point_weight_scale(id : int, weight_scale : float) -> void:
	.set_point_weight_scale(id, weight_scale)
	
	if not weight_scale == 1.0:
		scaled_points[id] = weight_scale
	else:
		scaled_points.erase(id)
