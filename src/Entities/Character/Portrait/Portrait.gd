extends TextureRect

signal new_photo_set(new_photo)

export (bool) var allow_edit : bool = false

onready var label : Label = ($Label as Label)
onready var fade : ColorRect = ($Overlay as ColorRect)



func _ready():
	if not allow_edit:
		label.queue_free()
		fade.queue_free()
	else:
		fade.connect("mouse_entered", self, "_on_Fade_mouse_entered")
		fade.connect("mouse_exited", self, "_on_Fade_mouse_exited")
		fade.connect("gui_input", self, "_on_Fade_gui_input")



func set_photo(new_photo : Texture) -> void:
	texture = new_photo
	emit_signal("new_photo_set", texture)



func _on_Fade_gui_input(event : InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and not has_node("PhotoSelecter"):
		var photo_selecter : PackedScene = load("res://src/Entities/Physical/Character/Portrait/PhotoSelecter.tscn")
		
		add_child(photo_selecter.instance())
		get_node("PhotoSelecter").connect("file_selected", self, "_on_PhotoSelecter_file_selected")
		get_node("PhotoSelecter").connect("popup_hide", self, "_on_PhotoSelecter_popup_hide")
		get_node("PhotoSelecter").popup()


func _on_PhotoSelecter_file_selected(path : String) -> void:
	var photo_cropper : Popup = load("res://src/Entities/Physical/Character/Portrait/PhotoCropper.tscn").instance()
	var selected_photo : Texture = load(path)
	
	print(selected_photo)
	add_child(photo_cropper)
	photo_cropper.set_photo(selected_photo)
	photo_cropper.connect("portrait_created", self, "_on_PhotoCropper_portrait_created", [], 1)
	photo_cropper.popup()


func _on_PhotoSelecter_popup_hide() -> void:
	get_node("PhotoSelecter").queue_free()


func _on_PhotoCropper_portrait_created(photo : Texture) -> void:
	set_photo(photo)
	get_node("PhotoCropper").queue_free()



func _on_Fade_mouse_entered():
	label.visible = true
	fade.color = Color(0,0,0,0.5)


func _on_Fade_mouse_exited():
	label.visible = false
	fade.color = Color(0,0,0,0)
