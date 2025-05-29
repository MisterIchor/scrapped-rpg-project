extends PanelContainer

var is_edit_mode_enabled : bool = false setget set_is_edit_mode_enabled

onready var section_name: HBoxContainer = $VBoxContainer/SectionName
onready var section_name_edit: LineEdit = $VBoxContainer/SectionName/SectionNameEdit
onready var section_name_label: Label = $VBoxContainer/SectionName/SectionNameLabel
onready var visibility_button: Button = $VBoxContainer/SectionName/VisibilityButton
onready var section_edit: TextEdit = $VBoxContainer/Section/MarginContainer/SectionEdit
onready var section_placeholder_text: Label = $VBoxContainer/Section/MarginContainer/SectionEdit/SectionPlaceholderText
onready var section_label: Label = $VBoxContainer/Section/MarginContainer/SectionLabel
onready var section: ScrollContainer = $VBoxContainer/Section




func _ready() -> void:
	section_edit.connect("text_changed", self, "_on_SectionEdit_text_changed")
	visibility_button.connect("toggled", self, "_on_VisibilityButton_toggled")



func set_is_edit_mode_enabled(value : bool) -> void:
	is_edit_mode_enabled = value
	section_name_edit.visible = is_edit_mode_enabled
	section_edit.visible = is_edit_mode_enabled
	section_name_label.visible = !is_edit_mode_enabled
	section_label.visible = !is_edit_mode_enabled
	
	if is_edit_mode_enabled:
		section_name_edit.text = section_name_label.text
		section_edit.text = section_label.text
	else:
		section_name_label.text = section_name_edit.text
		section_label.text = section_edit.text



func _on_SectionEdit_text_changed() -> void:
	section_placeholder_text.visible = section_edit.text.empty()


func _on_VisibilityButton_toggled(is_toggled : bool) -> void:
	section.visible = is_toggled
	visibility_button.text = "-" if !is_toggled else "+"
