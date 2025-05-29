extends MarginContainer

var soul : Soul = null setget set_soul
var is_selected : bool = false setget set_is_selected
var feed_shader : ShaderMaterial = null
var _selection_highlight_percentage : float = 0.0
var _selection_update_speed : float = 0.005
var _selection_increment : float = 0.1

onready var portrait : TextureRect = ($VBoxContainer/MarginContainer/Portrait as TextureRect)
onready var hr_monitor : PanelContainer = ($VBoxContainer/HRMonitor as PanelContainer)
onready var hr_line : ColorRect = ($VBoxContainer/HRMonitor/Line as ColorRect)
onready var vignette : TextureRect = ($VBoxContainer/MarginContainer/CRTVignette as TextureRect)
#onready var static_overlay : Control = add_overlay("res://src/Test/Static/Static.gd")



func _draw() -> void:
	if soul:
		var draw_size : Vector2 = rect_size
		
		draw_size.y *= _selection_highlight_percentage
		draw_rect(Rect2(0, rect_size.y, rect_size.x, -draw_size.y), 
				soul.get_value_from_container("appearance", "eye_color"))



func add_overlay(overlay_path : String) -> Control:
	var overlay : GDScript = load(overlay_path)
	
	for i in portrait.get_children():
		if i.get_script() == overlay:
			return null
	
	var overlay_object : Control = overlay.new()
	
	portrait.add_child(overlay_object)
	return overlay_object


func flash_portrait(colors : PoolColorArray, times_to_flash : int, time_between_flashes : float) -> void:
	var current_modulate : Color = portrait.modulate
	
	for i in times_to_flash:
		portrait.modulate = colors[wrapi(i, 0, colors.size())]
		yield(get_tree().create_timer(time_between_flashes, false), "timeout")
		portrait.modulate = current_modulate
		yield(get_tree().create_timer(time_between_flashes, false), "timeout")



func set_soul(new_soul : Soul) -> void:
	soul = new_soul
	
	if not soul:
		if feed_shader:
			feed_shader.set_shader_param("static_intensity", 1.0)
			feed_shader.set_shader_param("flicker_intensity", 1.0)
		
		portrait.self_modulate = Color(0.7, 0.7, 0.7)
		vignette.self_modulate.a = 0.9
		set_name("EmptyStatus")
		hr_monitor.flatline()
	else:
		if not feed_shader:
			feed_shader = ShaderMaterial.new()
			feed_shader.shader = preload("res://src/Test/Static/camera_feed.shader")
			portrait.material = feed_shader
		
		portrait.set_photo(soul.get_value_from_container("appearance", "custom_portrait"))
		feed_shader.set_shader_param("static_intensity", 0.0)
		feed_shader.set_shader_param("flicker_intensity", 0.0)
		portrait.self_modulate = Color(1, 1, 1)
		vignette.self_modulate.a = 0.43
		soul.connect("changed_value_sent", self, "_on_changed_value_sent")
		set_name(soul.get_value_from_container("soul_name", "full_name").replacen(" ", "") + "Status")
		hr_monitor.restore(soul.get_value_from_container("appearance", "hair_color"))


func set_is_selected(value : bool) -> void:
	is_selected = value
	
	while true:
		_selection_highlight_percentage += _selection_increment if is_selected else -_selection_increment
		_selection_highlight_percentage = clamp(_selection_highlight_percentage, 0, 1)
		update()
		
		if _selection_highlight_percentage <= 0 or _selection_highlight_percentage >= 1:
			break
		
		yield(get_tree().create_timer(_selection_update_speed), "timeout")



func _on_changed_value_sent(container_name : String, value_name : String, value_new, value_old) -> void:
	if value_name == "custom_portrait":
		portrait.set_photo(load(value_new))
	
	if container_name == "health":
		if value_name == "current":
			if value_new == 0:
				hr_monitor.flatline()
		
		var health_percentage : float = soul.get_container("health").get_percentage()
#		var height : float = 0.5 - (0.5 * (health_percentage))
		var variance : float = 0.2 + (0.2 - (0.2 * (health_percentage)))
		
		hr_line.beat_height = health_percentage
		hr_line.height_variance = variance
		hr_line.thickness = 1 + (2.0 * health_percentage)
		feed_shader.set_shader_param("shake_intensity", Vector2(1.0 - health_percentage, 0))
		feed_shader.set_shader_param("static_intensity", 1.0 - health_percentage)
		feed_shader.set_shader_param("flicker_intensity", 1.0 - health_percentage)
		feed_shader.set_shader_param("glitch_intensity", 1.0 - health_percentage)
		flash_portrait([Color(1.0, 0.0, 0.0, 1.0), Color(1.0, 0.0, 0.0, 0.8), Color(1.0, 0.0, 0.0, 0.6), Color(1.0, 0.0, 0.0, 0.4), Color(1.0, 0.0, 0.0, 0.2)], 5, 0.1)
	
	if container_name == "stamina":
		var rate : float = 0.5 - (0.5 * (soul.get_container("stamina").get_percentage()))
		hr_line.beat_rate = 1.0 - rate
