extends VisibilityNotifier2D

var circle_color : Color = Color.white
var max_radius : float = 30.0
var speed : float = 1.5
var loops : int = 1
var _current_radius : float = 0.0
var _current_loop : int = 0



func _init() -> void:
	connect("screen_entered", self, "_on_screen_entered")
	connect("screen_exited", self,"_on_screen_exited")
	set_process(false)


func _draw() -> void:
	draw_arc(Vector2(), _current_radius, -TAU, TAU, _current_radius + 5, circle_color, 3, true)


func _process(delta: float) -> void:
	_current_radius += speed
	
	if _current_radius > max_radius:
		if _current_loop >= loops:
			queue_free()
		
		_current_loop += 1
		_current_radius = 0.0
	
	update()



func _on_screen_entered() -> void:
	set_process(true)


func _on_screen_exited() -> void:
	set_process(false)
