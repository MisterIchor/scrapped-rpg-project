extends ColorRect

const DisplayContainerCatagory : PackedScene = preload("res://src/GlobalUI/CharacterSheet/Display/DisplayContainerCatagory.tscn")
const DisplayValueTrackerDetails : PackedScene = preload("res://src/GlobalUI/CharacterSheet/Display/DisplayValueTrackerDetails.tscn")

var soul : Soul = null setget set_soul

onready var attribute_page : VBoxContainer = ($Control/CharacterFeatures/VBoxContainer/ScrollContainer/Pages/Attributes as VBoxContainer)
onready var skill_page : VBoxContainer = ($Control/CharacterFeatures/VBoxContainer/ScrollContainer/Pages/Skills as VBoxContainer)
onready var features_pages : MarginContainer = ($Control/CharacterFeatures/VBoxContainer/ScrollContainer/Pages as MarginContainer)
#onready var character_features : Control = ($Control/PanelContainer/VBoxContainer/Sheet/CharacterFeatures as Control)
onready var character_info : Control = ($Control/PanelContainer/VBoxContainer/Sheet/CharacterInfo as Control)
onready var search_bar : PanelContainer = ($Control/PanelContainer/VBoxContainer/Sheet/CharacterFeatures/VBoxContainer/SearchBar as PanelContainer)
onready var search_results : VBoxContainer = ($Control/PanelContainer/VBoxContainer/Sheet/CharacterFeatures/VBoxContainer/ScrollContainer/SearchResults as VBoxContainer)
onready var character_card : Control = ($Control/CharacterInfo/HBoxContainer/Information/CharacterCard as Control)



func _ready() -> void:
	set_soul(PartySystem.get_leader())
#	search_bar.connect("search_started", self, "_on_SearchBar_search_started")
#	search_bar.connect("search_ended", self, "_on_SearchBar_search_ended")
#	search_bar.connect("results_sent", self, "_on_SearchBar_results_sent")
#	tabs_left.connect("tab_changed", self, "_on_Tabs_changed", [tabs_left])
#	tabs_right.connect("tab_changed", self, "_on_Tabs_changed", [tabs_right])
	
#	for i in character_info.get_children():
#		tabs_left.add_tab(i.name)
#
#	for i in features_pages.get_children():
#		tabs_right.add_tab(i.name)



func create_new_catagory(catagory_name : String) -> VBoxContainer:
	var new_catagory : VBoxContainer = VBoxContainer.new()
	var catagory_label : Label = Label.new()
	var seperator : HSeparator = HSeparator.new()

	new_catagory.name = catagory_name
	new_catagory.add_child(catagory_label, true)
	new_catagory.add_child(seperator, true)
	catagory_label.text = catagory_name.capitalize()
	catagory_label.valign = Label.VALIGN_CENTER
	catagory_label.align = Label.ALIGN_CENTER
	return new_catagory



func set_soul(new_soul : Soul) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	
	soul = new_soul
	character_card.set_soul(soul)
	
	for i in soul.get_containers().values():
		if not i is ValueTracker:
			continue
		
		if i.get("hide"):
			continue
		
		var page : VBoxContainer = attribute_page
		
		if i is Skill:
			page = skill_page
		
		var catagory : PanelContainer = page.get_node_or_null(i.get("catagory"))
	
		if not catagory:
			catagory = DisplayContainerCatagory.instance()
			page.add_child(catagory, true)
			catagory.set_name(i.get("catagory"))
			catagory.owner = self
		
		catagory.add_container(i, "current", load("res://src/GlobalUI/CharacterSheet/Display/DisplayValueTracker.tscn"))



func _on_SearchBar_search_started() -> void:
	features_pages.hide()
	search_results.show()


func _on_SearchBar_search_ended() -> void:
	features_pages.show()
	search_results.hide()


func _on_SearchBar_results_sent(new_results : Array) -> void:
	search_results.parse_new_results(new_results)
	
	if search_bar.get_current_catagory() == "Feature":
		for i in search_results.get_duped_results():
			if not i.is_connected("show_details", self, "_on_show_details"):
				i.connect("show_details", self, "_on_show_details")


func _on_show_details(tracker : ValueTracker) -> void:
	var display_value_details : Popup = DisplayValueTrackerDetails.instance()
	
	display_value_details.set_value_tracker(tracker)
	add_child(display_value_details)
	display_value_details.popup()
