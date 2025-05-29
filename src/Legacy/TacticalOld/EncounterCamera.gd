extends Camera2D

const ACCEL_CAM : float = 0.3
const SPEED_ZOOM : Vector2 = Vector2(0.05, 0.05)
const SPEED_CAM_MAX : float = 10.0

var speed_cam : Vector2 = Vector2()
var motion_dir : Vector2 = Vector2()
var target_dir : Vector2 = Vector2()
var is_smooth_camera_enabled : bool = false setget set_smooth_camera



func _ready() -> void:
	ConsoleSystem.add_node_to_console(self)


func _process(delta):
	target_dir = _get_input()
	
	if is_smooth_camera_enabled:
		_set_motion_dir()
		
		speed_cam.x = _set_cam_speed(motion_dir.x, target_dir.x, speed_cam.x)
		speed_cam.y = _set_cam_speed(motion_dir.y, target_dir.y, speed_cam.y)
		
		position += speed_cam * motion_dir.normalized()
	else:
		position += SPEED_CAM_MAX * target_dir.normalized()



func _get_input() -> Vector2:
	var input_direction : Vector2 = Vector2()
	input_direction.x = int(Input.is_action_pressed("cam_right")) - int(Input.is_action_pressed("cam_left"))
	input_direction.y = int(Input.is_action_pressed("cam_down")) - int(Input.is_action_pressed("cam_up"))
	return input_direction



func _set_motion_dir() -> void:
	if speed_cam.x == 0:
		motion_dir.x = target_dir.x
	if speed_cam.y == 0:
		motion_dir.y = target_dir.y


func _set_cam_speed(dir : int, target : int, dir_speed : float) -> float:
	var speed : float = dir_speed
	
	if target != 0 and speed <= SPEED_CAM_MAX:
		if target == dir:
			speed += ACCEL_CAM
		else:
			speed -= 1.25 * ACCEL_CAM
		speed = clamp(speed, 0, SPEED_CAM_MAX)
	else:
		speed += -ACCEL_CAM
	speed = clamp(speed, 0, 9999)
	
	return speed


func set_smooth_camera(value : bool) -> void:
	is_smooth_camera_enabled = value
