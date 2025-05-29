tool
extends PanelContainer

const SECTION : PackedScene = preload("res://src/Entities/Items/DocumentsRevised/Section.tscn")

var section_amount : int = 1 setget set_section_amount
var text_options : Dictionary = {
	section_selected = 0,
	text = String()
}
onready var section_container : HBoxContainer = ($SectionContainer as HBoxContainer)

signal selected(new_page)



func _init() -> void:
	if not is_connected("visibility_changed", self, "_on_visibility_changed"):
		connect("visibility_changed", self, "_on_visibility_changed")


#func _ready() -> void:
#	if not Engine.editor_hint:
#		text_options.clear()


func _process(_delta: float) -> void:
	if Engine.editor_hint:
		if not section_container:
			section_container = get_node_or_null("SectionContainer")



func add_section() -> void:
	var new_section : MarginContainer = SECTION.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	
	if section_container.get_child_count() > 0:
		new_section.set_separator_visibility(true)
		(get_section(0) as MarginContainer).size_flags_stretch_ratio = 0.99
	else:
		(get_section(0) as MarginContainer).size_flags_stretch_ratio = 1.0
	
	section_container.add_child(new_section)
	new_section.owner = self



func set_section_amount(new_amount : int) -> void:
	section_amount = new_amount
	
	if not section_container:
		yield(self, "ready")
	
	var count : int = section_container.get_child_count()
	
	if section_amount > count:
		add_section()
	elif section_amount < count:
		var section_amount_to_remove : int = count - section_amount
		
		for i in range(1, section_amount_to_remove + 1):
			section_container.get_child(count - i).queue_free()
	
	if Engine.editor_hint:
		if not text_options.section_selected:
			set("textop_section_selected", 0)
			property_list_changed_notify()


func set_text_in_section(section : int, new_text : String) -> void:
	get_section(section).set_text(new_text)
	
	if Engine.editor_hint:
		if text_options.text.empty():
			set("textop_text", get_text_from_section(text_options.section_selected))


func get_text_from_section(index : int) -> String:
	var sections : Array = get_sections()
	return sections[index].get_text() if not sections.empty() else String()


func get_text(raw : bool = false) -> String:
	var sections : Array = get_sections()
	var page_text : String = String()
	
	for i in sections:
		var section_text : String = i.get_text_raw() if raw else i.get_text()
		
		if section_text.empty():
			continue
		
		page_text += section_text
	
	return page_text


func get_section(index : int) -> Array:
	if not section_container:
		yield(self, "ready")
	
	return section_container.get_child(index)


func get_sections() -> Array:
	if not section_container:
		yield(self, "ready")
	
	return section_container.get_children()


func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "TextOptions",
		type = TYPE_NIL,
		hint_string = "textop_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "textop_selected_section",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0," + String(clamp(section_amount - 1, 0, 999))
	})
	
	property_list.append({
		name = "textop_text",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_MULTILINE_TEXT
	})
	
	return property_list


func _set(property: String, value) -> bool:
	if Engine.editor_hint:
		if not section_container:
			yield(self, "ready")
		
		match property:
			"textop_selected_section":
				text_options.section_selected = value
				
				var sections : Array = section_container.get_children()
				set("textop_text", sections[value].get_text())
				property_list_changed_notify()
			
			"textop_text":
				text_options.text = value
				
				var sections : Array = section_container.get_children()
				sections[text_options.section_selected].set_text(text_options.text)
	
	return false


func _get(property : String):
	match property:
		"textop_selected_section":
			return text_options.section_selected
		
		"textop_text":
			return text_options.text



func _on_page_changed(new_page : int) -> void:
	visible = (new_page == get_index())


func _on_visibility_changed() -> void:
	if visible:
		emit_signal("selected", get_index())
