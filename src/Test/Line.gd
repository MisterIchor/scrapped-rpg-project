extends ColorRect

const Beat : Dictionary = {
	lub = [Vector2(), Vector2(15, -30), Vector2(30, 0), Vector2(45, 0), 
			Vector2(60, 60), Vector2(75, 0), Vector2(90, -75), Vector2(105, 105),
			Vector2(120, 0), Vector2(150, 0), Vector2(165, -45), Vector2(180, 45),
			Vector2(195, -20), Vector2(210, 0)],
	dub = [Vector2(), Vector2(15, -60), Vector2(30, 45), Vector2(45, -30), 
			Vector2(60, 0)]
}

export (Color) var line_color : Color = Color.red setget set_line_color
export (float) var thickness : float = 1
export (float, 0.1, 2) var beat_rate : float = 1 setget set_beat_rate
export (float, 0.1, 2) var beat_speed : float = 1
export (float, 0, 1) var beat_height : float = 1
export (float, 0, 1) var height_variance : float = 0.2

var spawned_beats : Array = []

onready var rate_timer : Timer = ($Rate as Timer)



func _ready() -> void:
	rate_timer.connect("timeout", self, "_on_Rate_timeout")
	yield(get_tree().create_timer(rand_range(0, 1.0)), "timeout")
	rate_timer.start(beat_rate)


func _draw() -> void:
	var mid : float = rect_size.y / 2
	var thick_actual : float = 1 + ((thickness - 1) * beat_height)
	
	if not spawned_beats.empty():
		draw_line(Vector2(0, mid), Vector2(rect_size.x, mid), line_color.darkened(0.65), thick_actual)
	
	if spawned_beats.empty():
		draw_line(Vector2(0, mid), Vector2(rect_size.x, mid), line_color, thick_actual, true)
		return
	
	for i in range(spawned_beats.size()):
		var beat_type : Array = get_beat_type(spawned_beats[i].beat)
		
		for j in beat_type.size():
			beat_type[j].x *= spawned_beats[i].rate
			beat_type[j].x += spawned_beats[i].start_pos
			beat_type[j].y = clamp(beat_type[j].y, 
					-mid + 4, mid - 4) * spawned_beats[i].height
			beat_type[j].y += mid
		
		spawned_beats[i].end_pos = beat_type.back().x
		
		if not i == 0:
			draw_line(Vector2(spawned_beats[i].start_pos, mid), 
					Vector2(spawned_beats[i - 1].end_pos, mid), 
					line_color, thick_actual, true)
		
		draw_polyline(beat_type, line_color, thick_actual, true)
	
	var front : Vector2 = Vector2(0, mid)
	var back : Vector2 = Vector2(rect_size.x, mid)
	
	if spawned_beats.size() > 0:
		front = Vector2(spawned_beats.front().start_pos, mid)
		back = Vector2(spawned_beats.back().end_pos, mid)
	
	draw_line(Vector2(0, mid), front, line_color, thick_actual, true)
	draw_line(back, Vector2(rect_size.x, mid), line_color, thick_actual, true)


func _physics_process(delta: float) -> void:
	for i in spawned_beats:
		i.start_pos -= get_beat_speed() * delta
		i.end_pos -= get_beat_speed() * delta
		
		if i.start_pos <= -300:
			spawned_beats.erase(i)
	
	update()



func add_beat(beat_type : String) -> void:
	if not Beat.get(beat_type):
		return
	
	spawned_beats.append({
		beat = beat_type,
		height = get_beat_height(),
		rate = beat_rate,
		start_pos = rect_size.x,
		end_pos = Beat.get(beat_type).back().x + rect_size.x
	})



func set_line_color(new_color : Color) -> void:
	line_color = new_color
	color = new_color.darkened(0.85)


func set_beat_rate(new_rate : float) -> void:
	beat_rate = new_rate
	
	if not rate_timer:
		yield(self, "ready")
	
	rate_timer.wait_time = beat_rate



func get_beat_height() -> float:
	if not beat_height == 0.0:
		var rand_height : float = rand_range(beat_height - height_variance, beat_height + height_variance)
		return clamp(rand_height, 0, 999)
	
	return beat_height


func get_beat_speed() -> float:
	return 300 * beat_speed


func get_beat_type(type : String) -> Array:
	return Beat.get(type, []).duplicate()



func _on_Rate_timeout() -> void:
	rate_timer.stop()
	add_beat("lub")
	var time = 0.87 * (1.0 / beat_speed) * beat_rate
	yield(get_tree().create_timer(time, false), "timeout")
	add_beat("dub")
	rate_timer.start(beat_rate)
