extends Camera2D

const SPEED_ZOOM : float = 0.1
const SPEED_MOVE : float = 7.0

var target_zoom : float = 1.0
var target_rotation : float = 0.0
var restraints : Vector2 = Vector2(-21015, -21015)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		target_zoom -= SPEED_ZOOM
	elif event.is_action_pressed("zoom_out"):
		target_zoom += SPEED_ZOOM
	
	if event.is_action_pressed("cam_rotate_left"):
		target_rotation -= 45
	elif event.is_action_pressed("cam_rotate_right"):
		target_rotation += 45
	
	target_rotation = wrapf(target_rotation, -360, 360)
	target_zoom = clamp(target_zoom, 0.5, 2)



func _process(delta: float) -> void:
	var dir : Vector2 = Vector2()
	
	if Input.is_action_pressed("cam_up"):
		dir.y -= 1
	elif Input.is_action_pressed("cam_down"):
		dir.y += 1
	
	if Input.is_action_pressed("cam_left"):
		dir.x -= 1
	elif Input.is_action_pressed("cam_right"):
		dir.x += 1
	
	global_position += dir.rotated(rotation).normalized() * SPEED_MOVE
	
	if not restraints < Vector2():
		global_position.x = clamp(global_position.x, 0, restraints.x)
		global_position.y = clamp(global_position.y, 0, restraints.y)
	
	rotation = lerp_angle(rotation, deg2rad(target_rotation), 0.2)
	zoom = zoom.linear_interpolate(Vector2(target_zoom, target_zoom), 0.3)
