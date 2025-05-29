tool
extends ColorRect

signal amount_changed(new_amount)
signal page_changed(new_page)

enum DocumentType {BOOK, DOCUMENT}
const Page : PackedScene = preload("res://src/Entities/Items/DocumentsRevised/Page.tscn")

export (String, FILE, "*.document") var document : String = "" setget set_document
export (DocumentType) var type : int = DocumentType.BOOK setget set_type
export (Vector2) var size_per_section : Vector2 = Vector2(500, 600) setget set_size_per_section
export (int, 1, 999) var sections_per_page : int = 1 setget set_sections_per_page
export (int, 0, 999) var amount_of_pages : int = 0 setget set_amount_of_pages
# Covers will have only one sections regardless of sections_per_page
export (Dictionary) var cover : Dictionary = {
	front = false,
	back = false
} setget set_cover
export (int, 0, 999) var current_page : int = 0 setget set_current_page
export (PoolStringArray) var archive : PoolStringArray = []

var file_manager : FileManager = FileManager.new()
var text_export : Dictionary = {
	title = "",
	author = "",
	description = "",
	save_operation = "OVERWRITE",
} setget , get_text_export

onready var page_container : Movable = ($PageContainer as Movable)
onready var next_button : Button = ($DocumentControls/NextButton as Button)
onready var previous_button : Button = ($DocumentControls/PreviousButton as Button)



func _init() -> void:
	if not Engine.editor_hint:
		current_page = 0
	
	file_manager.folder_path = "res://assets/saved/documents"
	file_manager.file_type = ".document"
	file_manager.set_owner(self)
	file_manager.object_to_manage = self
	file_manager.add_value_to_manage("size_per_section", "set_size_per_section")
	file_manager.add_value_to_manage("sections_per_page", "set_sections_per_page")
	file_manager.add_value_to_manage("amount_of_pages", "set_amount_of_pages")
	file_manager.add_value_to_manage("cover", "set_cover")
	file_manager.add_value_to_manage("text_export", "", "get_text_export")
	file_manager.add_value_to_manage("_pages")


func _enter_tree() -> void:
	clear_pages()


func _ready() -> void:
	if not Engine.editor_hint:
		var scale : Vector2 = get_adjusted_scale()
		
		page_container.min_zoom = min(page_container.min_zoom, scale.x)
		page_container.max_zoom = max(page_container.max_zoom, scale.x)
		archive = PoolStringArray()
#		center_document()
		$ExitButton.connect("button_up", self, "_on_ExitButton_up")
		previous_button.connect("button_up", self, "_on_PreviousButton_up")
		next_button.connect("button_up", self, "_on_NextButton_up")
		$DocumentControls/CenterContainer/CenterButton.connect("button_up", self, "center_document")
		$DocumentControls.show()
	
	for i in get_all_as_array():
		connect("page_changed", i, "_on_page_changed")
		i.connect("selected", self, "_on_Page_selected")


func _process(delta: float) -> void:
	if Engine.editor_hint:
		if not page_container:
			page_container = get_node_or_null("PageContainer")
		
#		if not scroll_container:
#			scroll_container = get_node_or_null("ScrollContainer")


func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "TextExport",
		type = TYPE_NIL,
		hint_string = "textex_",
		usage = PROPERTY_USAGE_GROUP
	})
	
	property_list.append({
		name = "textex_title",
		type = TYPE_STRING
	})
	
	property_list.append({
		name = "textex_author",
		type = TYPE_STRING
	})
	
	property_list.append({
		name = "textex_description",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_MULTILINE_TEXT
	})
	
#	property_list.append({
#		name = "textex_save_operation",
#		type = TYPE_STRING,
#		hint = PROPERTY_HINT_ENUM,
#		hint_string = "OVERWRITE,NEW"
#	})
	
	property_list.append({
		name = "textex_export_text",
		type = TYPE_BOOL,
	})
	
	return property_list


func _set(property : String, value) -> bool:
	match property:
		"_pages":
			for i in value:
				match typeof(i):
					TYPE_STRING:
						get_covers()[i].set_text_in_section(0, value[i].c_unescape())
					
					TYPE_INT:
						for j in value[i]:
							get_page(i).set_text_in_section(j, value[i][j].c_unescape())
		
		"textex_title":
			text_export.title = value
		
		"textex_author":
			text_export.author = value
		
		"textex_description":
			text_export.description = value
		
#		"textex_save_operation":
#			text_export.save_operation = value
		
		"textex_export_text":
			if value:
				file_manager.save_file(text_export.title)
	
	return false


func _get(property: String):
	match property:
		"_pages":
			var all : Dictionary = get_all()
			var page_text : Dictionary = {}
			
			for i in all.covers:
					page_text[i] = all.covers[i].get_text().c_escape()
			
			for i in all.pages.size():
				var Page : PanelContainer = all.pages[i]
				page_text[i] = {}
				
				for j in Page.get_sections():
					page_text[i][j.get_index()] = j.get_text().c_escape()
			
			return page_text
	
		"textex_title":
			return text_export.title
		
		"textex_author":
			return text_export.author
		
		"textex_description":
			return text_export.description
		
#		"textex_save_operation":
#			return text_export.save_operation



func _update() -> void:
	if not is_page_visible() and not get_all_count() == 0:
		set_current_page(0)



func add_page() -> PanelContainer:
	var new_page : PanelContainer = Page.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	
	page_container.add_child(new_page, true)
	new_page.hide()
	new_page.owner = self
	new_page.set_section_amount(sections_per_page)
	connect("page_changed", new_page, "_on_page_changed")
	new_page.connect("selected", self, "_on_Page_selected")
	
	if get_cover(1):
		page_container.move_child(new_page, get_cover(1).get_index() - 1)
	
	return new_page


func clear_pages() -> void:
	for i in $PageContainer.get_children():
		i.free()


func center_document() -> void:
	if not Engine.editor_hint:
		var target : Dictionary = {
			scale = get_adjusted_scale(),
			pos = rect_size / 2
		}
		
		var equal : Dictionary = {
			scale = false,
			pos = false,
		}
		
		while false in equal.values():
			var inputs : Array = [
				Input.is_mouse_button_pressed(BUTTON_LEFT),
				Input.is_mouse_button_pressed(BUTTON_WHEEL_UP),
				Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN)
			]
			
			if true in inputs:
				break
		
			var container : Dictionary = {
				scale = page_container.rect_scale,
				pos = page_container.get_global_position_adjusted()
			}
		
			page_container.rect_global_position = container.pos.linear_interpolate(target.pos, 0.1)
			page_container.rect_scale = container.scale.linear_interpolate(target.scale, 0.1)
			equal.scale = page_container.rect_scale.is_equal_approx(target.scale)
			equal.pos = page_container.get_global_position_adjusted().is_equal_approx(target.pos)
			yield(get_tree().create_timer(0.00001), "timeout")
			prints(page_container.get_global_position_adjusted(), target.pos)
			
	page_container.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)






func set_amount_of_pages(new_amount : int) -> void:
	amount_of_pages = new_amount
	
	if not page_container:
		yield(self, "ready")
	
	var iter : int = get_page_count() - amount_of_pages
	
	for i in range(abs(iter)):
		match sign(iter):
			1.0:
#				var text_to_archive : PoolStringArray = []
				var last_page : PanelContainer = get_page(get_page_count() - 1)
				var text : String = last_page.get_text()
				
#				if not text.empty():
#					text_to_archive.append(text)
				
				last_page.free()
#				text_to_archive.invert()
#				archive.append_array(text_to_archive)
			-1.0:
				var new_page : PanelContainer = add_page()
				
#				if not archive.empty():
#					new_page.set_text(archive[0])
#					archive.remove(0)
	
	_update()
	property_list_changed_notify()



func set_current_page(new_page : int) -> void:
	if not page_container:
		yield(self, "ready")
	
	current_page = clamp(new_page, 0, get_all_count() - 1)
	page_container.rect_size.x = get_all_as_array()[current_page].section_amount * size_per_section.x
	emit_signal("page_changed", current_page)
	
#	if Engine.editor_hint:
#		center_document()
#	else:
	previous_button.disabled = current_page == 0
	next_button.disabled = current_page == get_all_count() - 1



func set_size_per_section(new_size : Vector2) -> void:
	size_per_section = new_size
	
	if not page_container:
		yield(self, "ready")
	
	page_container.rect_pivot_offset = size_per_section / 2
	page_container.rect_size = size_per_section
#	center_document()


func set_document(new_file : String) -> void:
	document = new_file
	
	if not page_container:
		yield(self, "ready")
	
	if not document.empty():
		file_manager.load_file(new_file.get_file())
		set_current_page(0)


func set_cover(new_dict : Dictionary) -> void:
	if not page_container:
		yield(self, "ready")
	
	for i in new_dict:
		if new_dict[i]:
			if not page_container.has_node(i.capitalize()):
				var new_cover : PanelContainer = add_page()
				new_cover.name = i.capitalize()
				new_cover.set_section_amount(1)
				
				if i == "front":
					page_container.move_child(new_cover, 0)
		elif page_container.has_node(i.capitalize()):
			page_container.get_node(i.capitalize()).free()

	_update()
	cover = new_dict


func set_sections_per_page(new_multiplier : int) -> void:
	sections_per_page = new_multiplier
	
	if not page_container:
		yield(self, "ready")
	
	for i in get_pages():
		i.set_section_amount(new_multiplier)
	
#	center_document()


func set_type(new_type : int) -> void:
#	if type == new_type:
#		return
#
	new_type = type
	var tabs : Control = get_node_or_null("Tabs")
	
	match type:
		DocumentType.BOOK:
			if tabs:
				tabs.queue_free()
		DocumentType.DOCUMENT:
			if not tabs:
				pass



func is_page_visible() -> bool:
	for i in get_all_as_array():
		if i.visible:
			return true
	
	return false


func get_all() -> Dictionary:
	if not page_container:
		yield(self, "ready")
	
	var all : Dictionary = {
		covers = get_covers(),
		pages = get_pages()
	}
	
	return all


func get_all_as_array() -> Array:
	if not page_container:
		yield(self, "ready")
	
	return page_container.get_children()


func get_all_count() -> int:
	return page_container.get_child_count()


func get_cover(index : int) -> PanelContainer:
	var covers : Dictionary = get_covers()
	
	match index:
		0:
			if covers.get("front"):
				return covers.front
		1:
			if covers.get("back"):
				return covers.back
	
	if index < 0 or index > 1:
		LogSystem.write_to_debug(name + ": cover index out of range. Input 0 for front, 1 for back.", 0)
	
	return null


func get_covers() -> Dictionary:
	if not page_container:
		yield(self, "ready")
	
	var covers : Dictionary = Dictionary()
	var pages : Array = page_container.get_children()
	
	if cover.front:
		covers.front = pages.front()
	
	if cover.back:
		covers.back = pages.back()
	
	return covers


func get_cover_count() -> int:
	var count : int = 0
	
	for i in cover.values():
		if i:
			count += 1
	
	return count


func get_page(index : int) -> PanelContainer:
	if not page_container:
		yield(self, "ready")
	
	var pages : Array = get_pages()
	
	if index > pages.size() - 1:
		return null
	
	return get_pages()[index] as PanelContainer


func get_page_count() -> int:
	if not page_container:
		yield(self, "ready")
	
	return max(page_container.get_child_count() - get_cover_count(), 0)


func get_pages() -> Array:
	if not page_container:
		yield(self, "ready")
	
	var pages : Array = page_container.get_children()
	
	if cover.front:
		pages.pop_front()
	
	if cover.back:
		pages.pop_back()
	
	return pages


func get_text_export() -> Dictionary:
	var data_to_export : Dictionary = text_export.duplicate()
	data_to_export.erase("save_operation")
	return data_to_export



func get_adjusted_scale() -> Vector2:
	var scale : Vector2 = Vector2()
	
	scale.x = (rect_size.x / size_per_section.x)
	scale.y = (rect_size.y / size_per_section.y)
	scale *= 0.97
	return Vector2(scale.x, scale.x) if scale.x < scale.y else Vector2(scale.y, scale.y)



func _on_Page_selected(index : int) -> void:
	set_current_page(index)
	property_list_changed_notify()


func _on_ExitButton_up() -> void:
	queue_free()


func _on_PreviousButton_up() -> void:
	set_current_page(current_page - 1)


func _on_NextButton_up() -> void:
	set_current_page(current_page + 1)
