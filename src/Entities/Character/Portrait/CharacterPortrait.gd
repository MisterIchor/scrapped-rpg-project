extends Control

onready var overlay : Control = ($Portrait/Picture/Overlay as Control)



func _ready():
	if overlay:
		overlay.connect("gui_input", self, "_on_Overlay_gui_input")



func _on_Overlay_gui_input(event : InputEvent) -> void:
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
	($Portrait as Control).set_photo(photo)
	get_node("PhotoCropper").queue_free()
