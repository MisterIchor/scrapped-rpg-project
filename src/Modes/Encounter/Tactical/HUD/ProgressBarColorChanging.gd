tool
extends ProgressBar
class_name ProgressBarColorChanging

export (PoolColorArray) var colors : PoolColorArray = [Color.black, Color.white]
var bar_color : StyleBoxFlat = null



func _ready() -> void:
	if not get_stylebox("fg") is StyleBoxFlat:
		add_stylebox_override("fg", StyleBoxFlat.new())
	
	bar_color = get_stylebox("fg")



func _set(property: String, value) -> bool:
	if property in ["value", "min_value", "max_value", "colors"]:
		var new_color : Color = get_color_gradiant(value / max_value)
		bar_color.bg_color = new_color
		bar_color.border_color = new_color.darkened(0.5)
	
	return false



func get_bar_color() -> Color:
	return bar_color.bg_color



func get_color_gradiant(percentage : float) -> Color:
	if colors.empty():
		return Color()
	elif colors.size() == 1:
		return colors[0]
	
	var color_count : float = colors.size()
	var increment : float = 1 / (color_count - 1)
	var increment_percentage : float = fmod(percentage, increment) / increment
	var color_one : int = clamp(percentage / increment, 0, color_count - 2)
	var color_two : int = min(color_one + 1, color_count - 1)
	var differance : Color = colors[color_two] - colors[color_one]
	var gradiant : Color = colors[color_one]
	
	if is_equal_approx(increment_percentage, 0) and is_equal_approx(percentage, 1):
		increment_percentage = 1
	
	gradiant += differance * increment_percentage
	return gradiant
