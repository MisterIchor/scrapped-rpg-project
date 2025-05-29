extends PanelContainer

var _last_tab_open : VBoxContainer = null
onready var pages : MarginContainer = ($VBoxContainer/Pages as MarginContainer)
onready var option_button : OptionButton = ($VBoxContainer/SearchBar/OptionButton as OptionButton)
onready var search_bar : LineEdit = ($VBoxContainer/SearchBar/Bar as LineEdit)



func _ready() -> void:
	for i in pages.get_children():
		i.connect("visibility_changed", self, "_on_Page_visibility_changed", [i])
	
	_last_tab_open = pages.get_child(0)
	search_bar.connect("text_changed", self, "_on_SearchBar_text_changed")



func _on_Page_visibility_changed(page : VBoxContainer) -> void:
	if page.visible:
		_last_tab_open = page


func _on_SearchBar_text_changed(new_text : String) -> void:
	var search_results : VBoxContainer = pages.get_node_or_null("SearchResults")
	
	if new_text.empty():
		if search_results:
			search_results.queue_free()
		
		
	elif not search_results:
		search_results = VBoxContainer.new()
		pages.add_child(search_results)
		
	
	match option_button.get_selected_id():
		# By feature.
		0:
			for i in pages.get_children():
				for j in i.get_children():
					
		# By Catagory.
		1:
			pass


