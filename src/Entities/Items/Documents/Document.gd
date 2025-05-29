extends "../Item.gd"



func _init() -> void:
	add_value("author", "")
	add_value("pages", [])
	add_value("current_page", -1)




func _set_template(new_template : DocumentTemplate) -> void:
	._set_template(new_template)
	
	if template:
		set_pages(template.pages)



func set_pages(new_pages : Array) -> void:
	_set_value("pages", new_pages)


func set_current_page(new_page : int) -> void:
	_set_value("current_page", new_page)
