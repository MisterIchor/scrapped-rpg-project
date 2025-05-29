extends ColorRect

var move_dir : String = "UP"
var speed : int = 3
var size : float = 25


func _init() -> void:
	anchor_right = 1
	color = Color(0.7, 0.7, 0.7, 0.3)


func _ready() -> void:
	rect_size.y = size
	if move_dir == "UP":
		rect_position.y = get_parent().rect_size.y


func _process(delta: float) -> void:
	if not get_parent():
		return
	
	match move_dir:
		"UP":
			rect_position.y -= speed
			
			if get_parent().rect_size.y + rect_position.y < 0:
				queue_free()
		
		"DOWN":
			rect_position.y += speed
			
			if rect_position.y > get_parent().rect_size.y:
				queue_free()
