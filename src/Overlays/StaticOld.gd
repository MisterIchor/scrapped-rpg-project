extends Control

export (int, 0, 999) var scan_line_size : int = 2
export (int, 1, 999) var scan_line_space : int = 6
export (float, 0, 1) var flicker_intensity : float = 0.0 setget set_flicker_intensity
export (float, 0, 1) var grey_intensity : float = 0.0
export (float, 0, 1) var static_intensity : float = 0.0
export (int, 1, 999) var static_size : int = 5

var grey_target : float = 0.0
var flicker_timer : Timer = Timer.new()



func _init():
	flicker_timer.connect("timeout", self, "_on_FlickerTimer_timeout")
	rect_clip_content = true


func _ready() -> void:
	update()
	add_child(flicker_timer)
	flicker_timer.start()


func _process(delta: float) -> void:
	call_deferred("update")


func _draw() -> void:
	draw_rect(Rect2(Vector2(), rect_size), Color(0.5, 0.5, 0.5, grey_target))
	
	for i in range(clamp(1000 * static_intensity, 200, 1000)):
		var static_position : Vector2 = Vector2(stepify(rand_range(0,rect_size.x), static_size), 
				stepify(rand_range(0, rect_size.y), static_size))
		var brightness : float = rand_range(0, 1)
		
		draw_rect(Rect2(static_position, Vector2(static_size, static_size)), 
				Color(brightness, brightness, brightness, clamp(0.5 * grey_intensity, 0.05, 1)))
	
	if scan_line_size == 0:
		return
	




func set_flicker_intensity(new_intensity : float) -> void:
	flicker_intensity = new_intensity
	
	if not flicker_timer:
		yield(self, "ready")
	
	flicker_timer.wait_time = clamp(1 - new_intensity, 0.01, 1)



func _on_FlickerTimer_timeout() -> void:
	grey_target = rand_range(clamp(grey_intensity, 0, 0.75), clamp(grey_intensity + (0.5 * grey_intensity), 0, 1))
