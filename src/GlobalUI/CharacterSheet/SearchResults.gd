extends VBoxContainer

var _current_results : Dictionary = {}

onready var no_results_text : Label = ($Label as Label)



func parse_new_results(new_results : Array) -> void:
	var results_to_remove : Dictionary = _current_results.duplicate()
	
	for i in new_results:
		if not _current_results.get(i):
			_current_results[i] = i.duplicate()
			add_child(_current_results[i])
		
		results_to_remove.erase(i)
	
	for i in results_to_remove:
		_current_results[i].queue_free()
		_current_results.erase(i)
	
	no_results_text.visible = _current_results.empty()



func get_duped_results() -> Array:
	var children : Array = get_children()
	children.pop_front()
	return children
