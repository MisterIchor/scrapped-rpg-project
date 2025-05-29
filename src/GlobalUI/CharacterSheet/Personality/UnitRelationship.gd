extends PanelContainer

var soul : Soul = null setget set_soul

onready var current_progress_bar: ProgressBar = $HBoxContainer/RelationshipInfo/CurrentRelationship/CurrentProgressBar
onready var overall_progress_bar: ProgressBar = $HBoxContainer/RelationshipInfo/OverallRelationship/OverallProgressBar
onready var relationship_color_background: ColorRect = $HBoxContainer/RelationshipColorBackground



func _ready() -> void:
	overall_progress_bar.connect("value_changed", self, "_on_ProgressBar_value_changed")
	relationship_color_background.color = overall_progress_bar.get_bar_color()



func set_soul(new_soul : Soul) -> void:
	soul = new_soul



func _on_ProgressBar_value_changed(value : float) -> void:
	relationship_color_background.color = overall_progress_bar.get_bar_color()
