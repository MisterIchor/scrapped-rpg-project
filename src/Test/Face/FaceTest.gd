tool
extends Node2D

export (bool) var reset_pos : bool = false setget reset_position
export (Dictionary) var default_pos : Dictionary = {
	left_eye = Vector2(),
	right_eye = Vector2(),
	left_pupil = Vector2(),
	right_pupil = Vector2(),
	look_pos = Vector2(),
	face = Vector2()
}

onready var look_pos : Position2D = ($LookPos as Position2D)
onready var left_eye : Sprite = ($LeftEye as Sprite)
onready var right_eye : Sprite = ($RightEye as Sprite)
onready var left_pupil : Sprite = ($LeftEye/Pupil as Sprite)
onready var right_pupil : Sprite = ($RightEye/Pupil as Sprite)
onready var face : Sprite = ($circle as Sprite)



func reset_position(value : bool) -> void:
	if value:
		look_pos.global_position = default_pos.look_pos



func _process(delta):
	if not left_eye or not right_eye:
		return
	
	
	var origin_diff : Vector2 = (look_pos.position - default_pos.look_pos).limit_length(1.5)
	look_pos.position = default_pos.look_pos + origin_diff
	
	var origin_diff_length : float = (look_pos.position - default_pos.look_pos).length()
	
	print(origin_diff_length)
	scale.x = 1.0 - (origin_diff_length * 0.15)
	face.position.x = lerp(face.position.x, default_pos.face.x + origin_diff.x, 0.5)
	face.position.y = lerp(face.position.y, default_pos.face.y + origin_diff.y, 0.5)
	
	left_eye.position.x = lerp(left_eye.position.x, default_pos.left_eye.x + (origin_diff.x * 3), 0.5)
	right_eye.position.x = lerp(right_eye.position.x, default_pos.right_eye.x + (origin_diff.x * 3), 0.5)
	
	left_eye.position.y = lerp(left_eye.position.y, default_pos.left_eye.y + (origin_diff.y * 3), 0.5)
	right_eye.position.y = lerp(right_eye.position.y, default_pos.right_eye.y + (origin_diff.y * 3), 0.5)
	
	left_pupil.position.y = lerp(left_pupil.position.y, origin_diff.y, 0.5)
	right_pupil.position.y = lerp(right_pupil.position.y, origin_diff.y, 0.5)

	left_pupil.position.x = lerp(left_pupil.position.x, origin_diff.x, 0.5)
	right_pupil.position.x = lerp(right_pupil.position.x, origin_diff.x, 0.5)
