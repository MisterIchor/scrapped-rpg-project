tool
extends TextureRect

export (Vector2) var eye_size : Vector2 setget set_eye_size
export (Vector2) var iris_size : Vector2 setget set_iris_size
export (Texture) var iris_texture : Texture = null setget set_iris_texture
export (float, 0.0, 1.0) var blink_percentage : float = 0.0 setget set_blink_percentage
export (float, 0.0, 1.0) var eyelid_mid : float = 0.5 setget set_eyelid_mid
export (float) var iris_constraint : float = 1.0
export (float) var pupil_size : float = 1.0 setget set_pupil_size
export (bool) var reset_iris_position : bool = false setget set_iris_pos_to_origin
#export (Texture) var eye_lid_texture : Texture = null

var iris_origin : Vector2 = Vector2(64, 64) / 2

onready var eye_lid : TextureRect = ($EyeLid as TextureRect)
onready var iris : TextureRect = ($Iris as TextureRect)
onready var pupil : TextureRect = ($Iris/Pupil as TextureRect)



func _ready() -> void:
	eye_lid.texture = texture
	eye_lid.rect_size = rect_size



func set_eye_size(new_size : Vector2) -> void:
	if not get_iris_mid():
		yield(self, "ready")
	
	eye_size = new_size
	rect_size = eye_size
	rect_pivot_offset = eye_size / 2
	iris_origin = (eye_size / 2) - get_iris_mid()


func set_blink_percentage(new_percentage : float) -> void:
	blink_percentage = new_percentage
	eye_lid.material.set_shader_param("blink_percentage", new_percentage)


func set_eyelid_mid(new_mid : float) -> void:
	eyelid_mid = new_mid
	eye_lid.material.set_shader_param("mid", eyelid_mid)


func set_iris_size(new_size : Vector2) -> void:
	iris_size = new_size
	iris.rect_size = iris_size
	iris.rect_pivot_offset = iris_size / 2


func set_iris_texture(new_texture : Texture) -> void:
	iris_texture = new_texture
	
	if not iris:
		yield(self, "ready")
	
	iris.texture = iris_texture


func set_iris_pos_to_origin(lol : bool) -> void:
	if lol:
		iris.rect_position = iris_origin


func set_pupil_size(new_size : float) -> void:
	pupil_size = new_size
	pupil.rect_scale = Vector2(new_size, new_size)



func get_iris_origin_difference(constrained : bool = true) -> Vector2:
	var difference : Vector2 = (iris.rect_position) - iris_origin
	
	if constrained:
		difference = difference.limit_length(iris_constraint)
	
	return difference


func get_iris_mid() -> Vector2:
	return iris_size / 2


func get_pupil_mid() -> Vector2:
	return pupil.rect_size / 2



func _process(delta : float) -> void:
	if not iris:
		return
	
	iris.rect_position = iris_origin + get_iris_origin_difference()
	pupil.rect_position = (get_iris_mid() - get_pupil_mid()) + (get_iris_origin_difference() / 4)
