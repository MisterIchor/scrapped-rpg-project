extends Sprite

const UP_LEFT : Vector2 = Vector2(1, 0)
const UP : Vector2 = Vector2(1, 1)
const UP_RIGHT : Vector2 = Vector2(0, 1)
const RIGHT : Vector2 = Vector2(-1, 1)
const DOWN_RIGHT : Vector2 = Vector2(-1, 0)
const DOWN : Vector2 = Vector2(-1, -1)
const DOWN_LEFT : Vector2 = Vector2(0, -1)
const LEFT : Vector2 = Vector2(1, -1)

var vertical_index : int = 0
var horizontal_index : int = 0



func set_vertical_index(new_value : int) -> void:
	vertical_index = new_value



func get_vertical_index() -> int:
	return vertical_index * 8


func get_direction_index(direction : Vector2) -> int:
	match direction:
		UP:
			return 0
		UP_RIGHT:
			return 1
		RIGHT:
			return 2
		DOWN_RIGHT:
			return 3
		DOWN:
			return 4
		DOWN_LEFT:
			return 5
		LEFT:
			return 6
		UP_LEFT:
			return 7
	
	return -999



func _on_turned(new_direction : Vector2) -> void:
	horizontal_index = get_direction_index(new_direction)
	set_frame(get_vertical_index() + horizontal_index)


func _on_stance_changed(new_stance : String) -> void:
	match new_stance:
		"standing":
			vertical_index = 0
		"crouching":
			vertical_index = 1
		"prone":
			vertical_index = 2
	
	set_frame(get_vertical_index() + horizontal_index)
