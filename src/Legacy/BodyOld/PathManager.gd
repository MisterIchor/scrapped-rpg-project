extends Node2D

var path_actual : PoolVector2Array = []
var path_mapped : PoolVector2Array = []
var path_current : PoolVector2Array = []


func remove_points_on_path(path : Array, start : int, end : int) -> Array:
	var new_path : Array = path.duplicate(true)
	new_path.invert()
	
	for i in range(end, start, -1):
		new_path.remove(i)
	
	new_path.invert()
	return new_path





#func remove_point() -> void:
#	if not path_actual.size() > 0:
#		return
#
#	var start_idx : int = Array(path_mapped).find_last(path_actual[-2])
#	var end_idx : int = Array(path_mapped).find_last(path_actual[-1]) + 1
#
#	if path_actual.size() < 2:
#		path_actual.remove(0)
#	else:
#		path_actual.remove(path_actual.size() - 2)
#	path_actual.remove(path_actual.size() - 1)
#
#	strip_mapped_path(start_idx, end_idx)
