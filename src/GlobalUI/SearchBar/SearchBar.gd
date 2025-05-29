tool
extends PanelContainer

class SortAscending:
	static func sort(a, b):
		if a[1] < b[1]:
			return true
		return false

signal search_started
signal results_sent(new_results)
signal search_ended

export (NodePath) var node_to_search : NodePath = NodePath() setget set_node_to_search
# search_depth is a series of dictionaries with the following structure:
# {
#	name = "catagory_name,
#	depth = 0,
#	name_of_node_to_continue = String(),
# }
# Where depth is the how many branches deep this node will search the node_to_search's
# children, with 0 being the only the node_to_search's children.
# name is the name that will appear in the catagory_button's list of 
# options.
# name_of_node_to_continue is the node that will be entered when searching deeper.
# If no node is found or the string is empty, will default to the first node in a 
# branch.
# Will be ignored if depth == 0.
export (Array) var search_depth : Array = [] setget set_search_depth

var _is_searching : bool = false

onready var line_edit : LineEdit = ($PanelContainer/LineEdit as LineEdit)
onready var catagory_button : OptionButton = ($PanelContainer/CatagoryButton as OptionButton)



func _ready() -> void:
	for i in search_depth:
		catagory_button.add_item(i.name)
	
	line_edit.connect("text_changed", self, "_on_LineEdit_text_changed")
#	catagory_button.connect("item_selected", self, "_on_Catagory_item_selected")



func _compare_strings(string_one : String, string_two : String) -> float:
	var similarity : float = 0.0
	var success_increment : float = 1.0 / string_one.length()
	
	string_one = string_one.to_lower()
	string_two = string_two.to_lower()
	
	for i in string_two.length():
		print(typeof(i))
		if string_one[i] == string_two[i]:
			similarity += success_increment
		else:
			break
	
	return similarity



func search_node(node : Node, keyword : String, depth : int = 0, 
			name_of_node_to_continue : String = "") -> Array:
	var results : Array = []
	
	if depth == 0:
		for i in node.get_children():
			var similarity : float = _compare_strings(i.name, keyword)
			prints(i.name, keyword, similarity)
			
			if not similarity <= 0.0:
				results.append([i, similarity])
	else:
		for i in node.get_children():
			var node_at_depth : Node = i
			var current_depth : int = 0
			
			while not current_depth >= depth:
				if name_of_node_to_continue:
					if node_at_depth.has_node(name_of_node_to_continue):
						node_at_depth = node_at_depth.get_node(name_of_node_to_continue)
						current_depth += 1
						continue
				
				node_at_depth = node_at_depth.get_child(0)
				current_depth += 1
			
			for j in node_at_depth.get_children():
				var similarity : float = _compare_strings(j.name, keyword)
				
				if not similarity <= 0.0:
					results.append([j, similarity])
	
	if results.empty():
#		breakpoint
		return results
	
	results.sort_custom(SortAscending, "sort")
	
	for i in results.size():
		results[i] = results[i][0]
	
	return results



func set_node_to_search(node_path : NodePath) -> void:
	node_to_search = node_path
	
	if _is_searching and is_inside_tree():
		var catagory : Dictionary = search_depth[catagory_button.get_selected_id()]
		
		emit_signal("results_sent", search_node(get_node(node_to_search), line_edit.text, 
				catagory.depth, catagory.name_of_node_to_continue))


func set_search_depth(new_array : Array) -> void:
	search_depth = new_array
	
	for i in search_depth.size():
		if not search_depth[i]:
			search_depth[i] = {
				name = "catagory_name",
				depth = 0,
				name_of_node_to_continue = "",
			}


func get_current_catagory() -> String:
	return catagory_button.get_item_text(catagory_button.get_selected_id())



func _on_LineEdit_text_changed(new_text : String) -> void:
#	print(new_text if not new_text.empty() else "empty")
	if new_text.empty():
		if _is_searching == true:
			emit_signal("search_ended")
	elif _is_searching == false:
		emit_signal("search_started")
	
	_is_searching = not new_text.empty()
	
	if _is_searching:
		var catagory : Dictionary = search_depth[catagory_button.get_selected_id()]
		
		emit_signal("results_sent", search_node(get_node(node_to_search), new_text, 
				catagory.depth, catagory.name_of_node_to_continue))
