extends TextureRect

export (int, 0, 999) var scan_line_size : int = 2
export (int, 1, 999) var scan_line_space : int = 6
export (float, 0, 1) var flicker_intensity : float = 0.0 setget set_flicker_intensity
export (float, 0.1, 1) var alpha : float = 0.1
export (int, 1, 999) var static_size : int = 5 setget set_static_size

var alpha_target : float = 0.0
var flicker_timer : Timer = Timer.new()



func _init():
	flicker_timer.connect("timeout", self, "_on_FlickerTimer_timeout")
	rect_clip_content = true


func _ready() -> void:
#	update()
	add_child(flicker_timer)
	flicker_timer.start()


#func _draw():
#	for i in range(0, rect_size.y, scan_line_space):
#		draw_line(Vector2(0, i), Vector2(rect_size.x, i), Color(1, 1, 1, 0.2), scan_line_size)


func _process(delta: float) -> void:
	self_modulate.a = alpha
	texture.noise.seed += 1



func set_static_size(new_size : int) -> void:
	static_size = new_size
	texture.width = static_size
	texture.height = static_size


func set_flicker_intensity(new_intensity : float) -> void:
	flicker_intensity = new_intensity
	
	if not flicker_timer:
		yield(self, "ready")
	
	flicker_timer.wait_time = clamp(1 - new_intensity, 0.01, 1)



func _on_FlickerTimer_timeout() -> void:
	alpha_target = rand_range(clamp(alpha, 0, 0.75), clamp(alpha + (0.5 * alpha), 0, 1))
