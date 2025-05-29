extends Node

const UP_LEFT : Vector2 = Vector2(1, 0)
const UP : Vector2 = Vector2(1, 1)
const UP_RIGHT : Vector2 = Vector2(0, 1)
const RIGHT : Vector2 = Vector2(-1, 1)
const DOWN_RIGHT : Vector2 = Vector2(-1, 0)
const DOWN : Vector2 = Vector2(-1, -1)
const DOWN_LEFT : Vector2 = Vector2(0, -1)
const LEFT : Vector2 = Vector2(1, -1)



func convert_dir_array_to_rot(dir_array : Array) -> Array:
	var new_array : Array = dir_array
	
	for i in range(dir_array.size()):
		new_array[i] = dir_to_rot(new_array[i])
	
	return new_array


func dir_to_rot(direction : Vector2) -> int:
	match direction:
		UP:
			return 0
		UP_RIGHT:
			return 45
		RIGHT:
			return 90
		DOWN_RIGHT:
			return 135
		DOWN:
			return 180
		DOWN_LEFT:
			return -135
		LEFT:
			return -90
		UP_LEFT:
			return -45
	
	return -999


func get_processed_dir_array(dir_current : Vector2, dir_new : Vector2) -> Array:
	var dir : Array = get_directions()
	var dir_size : int = dir.size()
	var dir_new_index : int = 0
	
	while dir.front() != dir_current:
		dir.push_front(dir.pop_back())
	
	dir_new_index = dir.find(dir_new)
	
	if dir_new_index > 4:
		for i in range(dir_size - dir_new_index):
			dir.push_front(dir.pop_back())
		
		dir.resize(dir.find(dir_current))
		dir.invert()
	else:
		dir.resize(dir.find(dir_new) + 1)
	
	return dir


func rot_to_dir(rotation : int) -> Vector2:
	match stepify(rotation, 45):
		0.0:
			return LEFT
		45.0:
			return UP_LEFT
		90.0:
			return UP
		135.0:
			return UP_RIGHT
		180.0, -180.0:
			return RIGHT
		-45.0:
			return DOWN_LEFT
		-90.0:
			return DOWN
		-135.0:
			return DOWN_RIGHT

	return Vector2()



static func get_directions() -> Array:
	return [LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT]


func get_directions_world() -> Array:
	var new_array : Array = get_directions()
	
	for i in range(new_array.size()):
		new_array[i] *= Vector2(16, 16)
	
	return new_array
