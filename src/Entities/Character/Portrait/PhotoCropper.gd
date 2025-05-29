extends PopupPanel

onready var photo_box : HBoxContainer = ($VBoxContainer/PhotoBox as HBoxContainer)
onready var viewport : Viewport = ($VBoxContainer/PhotoBox/PreviewPhoto/Preview/Viewport as Viewport)
var photo_name : String = "Unnamed"

signal portrait_created(path)



func _ready():
	call_deferred("popup")
	($VBoxContainer/Button/Cancel as Button).connect("button_up", self, "_on_Cancel_button_up")
	($VBoxContainer/Button/Create as Button).connect("button_up", self, "_on_Create_button_up")



func set_photo(new_photo : Texture) -> void:
	photo_box.selected_photo.set_texture(new_photo)
	photo_box.preview_photo.set_texture(new_photo)



func _on_Create_button_up() -> void:
	var path : String = str("res://assets/portraits/", photo_name, ".PNG")
	var image : Image = viewport.get_texture().get_data()
	var photo : ImageTexture = ImageTexture.new()
	
	image.flip_y()
	image.save_png(path)
	photo.create_from_image(image, 0)
	emit_signal("portrait_created", photo)


func _on_Cancel_button_up() -> void:
	queue_free()
