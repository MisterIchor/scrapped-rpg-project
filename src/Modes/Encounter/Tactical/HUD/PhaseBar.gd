tool
extends ProgressBarColorChanging

signal bar_filled

var fill : Dictionary = {
	enabled = false,
	drain_if_disabled = false,
	speed = 5,
	colors = [Color.black, Color.white],
}
var flash : Dictionary = {
	enabled = false,
}



func _ready() -> void:
	bar_color = get_stylebox("fg")


func _process(delta: float) -> void:
	if Engine.editor_hint:
		if not bar_color:
			bar_color = get_stylebox("fg")
	
	if fill.enabled:
		value += fill.speed
	else:
		if fill.drain_if_disabled:
			set_process(false)
			return
		
		value = lerp(value, 0.0, 0.05)
		
		if value <= 0.01:
			value = 0
			set_process(false)
	
	var percentage : float = value / max_value if not is_equal_approx(value, 0) else 0
	var color : Color = get_fill_color_gradiant(percentage)
	bar_color.bg_color = color
	bar_color.border_color = color.darkened(0.5)
	
	if is_equal_approx(value, max_value):
		emit_signal("bar_filled")


func _get_property_list() -> Array:
	var properties : Array = []
	
	properties.append({
		name = "FillSettings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint_string = "fill_"
	})
	
	properties.append({
		name = "fill_speed",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "fill_colors",
		type = TYPE_COLOR_ARRAY
	})
	
	properties.append({
		name = "fill_drain_if_disabled",
		type = TYPE_BOOL
	})
	
	properties.append({
		name = "fill_enabled",
		type = TYPE_BOOL
	})
	
	
	properties.append({
		name = "FlashSettings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint_string = "flash_"
	})
	
	properties.append({
		name = "flash_enabled",
		type = TYPE_BOOL
	})
	
#	properties.append({
#		name = "flash_speed",
#		type = TYPE_REAL
#	})
	
	return properties


func _set(property: String, value) -> bool:
	match property:
		"fill_drain_if_disabled":
			fill.drain_if_disabled = value
			
			if not fill.enabled and is_processing():
				set_process(false)
			elif not fill.drain_if_disabled and not get("value") == 0:
				set_process(true)
		"fill_enabled":
			fill.enabled = value
			
			if fill.enabled and not is_processing():
				set_process(true)
			elif is_equal_approx(get("value"), 0):
				set_process(false)
		"fill_speed":
			fill.speed = value
		"fill_colors":
			fill.colors = value
		"flash_enabled":
			flash.enabled = value
			material.set_shader_param("is_flashing", flash.enabled)
#		"flash_speed":
#			flash.speed = value
	
	return false


func _get(property: String):
	match property:
		"fill_enabled":
			return fill.enabled
		"fill_drain_if_disabled":
			return fill.drain_if_disabled
		"fill_speed":
			return fill.speed
		"fill_colors":
			return fill.colors
		"flash_enabled":
			return flash.enabled
#		"flash_speed":
#			return flash.speed



func get_fill_color_gradiant(percentage : float) -> Color:
	if fill.colors.empty():
		return Color()
	elif fill.colors.size() == 1:
		return fill.colors.front()
	
	var color_count : float = fill.colors.size()
	var increment : float = 1 / (color_count - 1)
	var increment_percentage : float = fmod(percentage, increment) / increment
	var color_one : int = clamp(percentage / increment, 0, color_count - 2)
	var color_two : int = min(color_one + 1, color_count - 1)
	var differance : Color = fill.colors[color_two] - fill.colors[color_one]
	var gradiant : Color = fill.colors[color_one]
	
	if is_equal_approx(increment_percentage, 0) and is_equal_approx(percentage, 1):
		increment_percentage = 1
	
	gradiant += differance * increment_percentage
	return gradiant
