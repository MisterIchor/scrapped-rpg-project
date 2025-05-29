tool
extends PanelContainer

export (float, 0.0, 1.0) var openness : float = 0.5 setget set_openness
export (float, 0.0, 1.0) var conscientiousness : float = 0.5 setget set_conscientiousness
export (float, 0.0, 1.0) var extraversion : float = 0.5 setget set_extraversion
export (float, 0.0, 1.0) var agreeableness : float = 0.5 setget set_agreeableness
export (float, 0.0, 1.0) var neuroticism : float = 0.5 setget set_neuroticism



func _ready() -> void:
	connect("resized", self, "update")



func _draw() -> void:
	var _default_pos : Dictionary = {
		openness = Vector2(rect_size.x / 2, rect_size.y * 0.95),
		conscientiousness = Vector2(rect_size.x * 0.95, rect_size.y / 2),
		extraversion = Vector2(rect_size.x * 0.05, rect_size.y / 2),
		agreeableness = Vector2(rect_size.x * 0.75, rect_size.y * 0.05),
		neuroticism = Vector2(rect_size.x * 0.25, rect_size.y * 0.05),
	}
	var polygon : PoolVector2Array = []
	var rect_mid : Vector2 = rect_size / 2
	
	
	polygon.resize(6)
	polygon.set(0, (rect_mid - _default_pos.openness) * openness)
	polygon.set(4, (rect_mid - _default_pos.conscientiousness) * conscientiousness)
	polygon.set(1, (rect_mid - _default_pos.extraversion) * extraversion)
	polygon.set(3, (rect_mid - _default_pos.agreeableness) * agreeableness)
	polygon.set(2, (rect_mid - _default_pos.neuroticism) * neuroticism)
	polygon.set(5, polygon[0])
	
	for i in polygon.size():
		polygon.set(i, polygon[i] + rect_mid)
	
	polygon.invert()
	draw_polyline(polygon, Color.white, 1.0, true)



func set_openness(value : float) -> void:
	openness = value
	update()


func set_conscientiousness(value : float) -> void:
	conscientiousness = value
	update()


func set_extraversion(value : float) -> void:
	extraversion = value
	update()


func set_agreeableness(value : float) -> void:
	agreeableness = value
	update()


func set_neuroticism(value : float) -> void:
	neuroticism = value
	update()
