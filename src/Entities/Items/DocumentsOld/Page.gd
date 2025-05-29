tool
extends Node

export (String, "Page", "Cover") var type : String setget set_type	
export (Vector2) var page_size : Vector2 = Vector2(500, 300) setget set_page_size

var container : PanelContainer = ($"." as PanelContainer)


func _ready() -> void:
	if not Engine.editor_hint:
		var right_page : VBoxContainer = ($PageContainer/RightPage as VBoxContainer)
		var seperator : VSeparator = ($PageContainer/VSeparator as VSeparator)
		if type == "Cover":
			right_page.free()
			seperator.free()


func set_page_size(new_size : Vector2) -> void:
	page_size = new_size
	call_deferred("_set_page_size")

func set_type(new_type : String) -> void:
	type = new_type
	call_deferred("_set_type")


func _set_page_size() -> void:
	var size : Vector2 = page_size if type == "Page" else Vector2(page_size.x / 2, page_size.y)
	container.set_margin(MARGIN_LEFT, -size.x)
	container.set_margin(MARGIN_RIGHT, size.x)
	container.set_margin(MARGIN_TOP, -size.y)
	container.set_margin(MARGIN_BOTTOM, size.y)

func _set_type() -> void:
	if Engine.editor_hint:
		var right_page : VBoxContainer = ($PageContainer/RightPage as VBoxContainer)
		var seperator : VSeparator = ($PageContainer/VSeparator as VSeparator)
		match type:
			"Page":
				right_page.show()
				seperator.show()
			"Cover":
				right_page.hide()
				seperator.hide()
		_set_page_size()
		container.rect_pivot_offset = container.rect_size / 2
