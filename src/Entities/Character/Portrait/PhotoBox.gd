extends HBoxContainer

const CAM_ZOOM_DEFAULT : Vector2 = Vector2(0.165, 0.415)

onready var selected_photo : TextureRect = ($SelectedPhoto as TextureRect)
onready var preview_photo : TextureRect = ($PreviewPhoto/Preview/Viewport/TextureRect as TextureRect)
onready var crop_box : ColorRect = ($SelectedPhoto/CropBox as ColorRect)
onready var camera : Camera2D = ($PreviewPhoto/Preview/Viewport/TextureRect/Camera2D as Camera2D)



func _ready() -> void:
	preview_photo.rect_size = selected_photo.rect_size


func _process(delta: float) -> void:
	camera.set_offset((crop_box.get_scaled_size() / 2) + crop_box.get_position_offset())
	camera.set_global_position(crop_box.get_position())
	camera.set_zoom(crop_box.rect_scale)



