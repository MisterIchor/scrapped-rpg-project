extends Node2D

const LOSTracker : GDScript = preload("res://src/Entities/Character/Body/LOS/LOSTracker.gd")

var dir : Vector2 = Vector2()
var units_unblocked : Array = []



func _physics_process(delta: float) -> void:
	units_unblocked.clear()
	
	for tracker in get_children():
		if tracker.is_colliding():
			if tracker.get_collider().owner == tracker.target:
				units_unblocked.append(tracker.target)


func add_tracker(target) -> RayCast2D:
	if not target is Unit and target is Node2D:
		return null
	
	if has_node(str(target.name, "Tracker")):
		return null
	
	var new_tracker : RayCast2D = LOSTracker.new(target)
	
	add_child(new_tracker)
	return new_tracker



func get_trackers() -> Dictionary:
	var trackers : Dictionary = {}
	
	for i in get_children():
		trackers[i.target] = i
	
	return trackers


func get_units_unblocked_distance_sorted() -> Array:
	if not units_unblocked.size() > 1:
		return units_unblocked
	
	var sorted_array : Array = []
	
	for i in units_unblocked.size() - 1:
		var unit_one : Unit = units_unblocked[i]
		var unit_two : Unit = units_unblocked[i + 1]
		var distance_one : float = unit_one.get_body_position().distance_squared_to(global_position)
		var distance_two : float = unit_two.get_body_position().distance_squared_to(global_position)
		
		if distance_one > distance_two:
			sorted_array.append(unit_one)
		else:
			sorted_array.append(unit_two)
	
	return sorted_array
