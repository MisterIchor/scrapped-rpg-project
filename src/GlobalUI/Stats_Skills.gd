tool
extends ColorRect

const AttributeDisplayBar : PackedScene = preload("res://src/GlobalUI/CharacterSheet/AttributeDisplayValue.tscn")
const AttributeDisplayValue : PackedScene = preload("res://src/GlobalUI/CharacterSheet/AttributeDisplayValue.tscn")

var soul : Soul = null setget set_soul

onready var character_stats : Control = ($Control/CharacterStats as Control)
onready var character_info : Control = ($Control/CharacterInfo as Control)
onready var tabs_left : Tabs = ($Control/TabsLeft as Tabs)
onready var tabs_right : Tabs = ($Control/TabsRight as Tabs)



func _ready() -> void:
	tabs_left.connect("tab_changed", self, "_on_Tabs_changed", [tabs_left])
	tabs_right.connect("tab_changed", self, "_on_Tabs_changed", [tabs_right])
	
	for i in character_info.get_children():
		tabs_left.add_tab(i.name)
	
	for i in character_stats.get_children():
		tabs_right.add_tab(i.name)
#
#			if not i.get_index() == 0:
#				i.hide()



func _on_Tabs_changed(tab_idx : int, tabs : Tabs) -> void:
	match tabs:
		tabs_left:
			character_info.get_child(tab_idx).show()
			character_info.get_child(tabs.get_previous_tab()).hide()
		tabs_right:
			character_stats.get_child(tab_idx).show()
			character_stats.get_child(tabs.get_previous_tab()).hide()
