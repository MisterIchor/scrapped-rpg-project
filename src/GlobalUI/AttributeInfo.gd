extends Button

var attribute_container : Attribute = null setget set_attribute_container
var _show_details : bool = false setget _set_show_details

onready var attribute_label : Label = ($HBoxContainer/AttributeLabel as Label)
onready var total_label : Label = ($HBoxContainer/TotalLabel as Label)
onready var details_container : VBoxContainer = ($Details/DetailsContainer as VBoxContainer)
onready var details : PanelContainer = ($Details as PanelContainer)
onready var hover_timer : Timer = ($HoverTimer as Timer)



func _init() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _ready() -> void:
	hover_timer.connect("timeout", self, "_on_HoverTimer_timeout")


func _process(delta: float) -> void:
	if _show_details:
		details.rect_scale.y = lerp(details.rect_scale.y, 1, 0.25)
	else:
		details.rect_scale.y = lerp(details.rect_scale.y, 0, 0.25)
	
	if is_equal_approx(details.rect_scale.y, 0):
		details.rect_scale.y = 0
		set_process(false)
	else:
		yield(get_tree().create_timer(0.1), "timeout")



func set_attribute_container(new_container : Attribute) -> void:
	if not attribute_label:
		yield(self, "ready")
	
	attribute_container = new_container
	attribute_container.connect("value_changed", self, "_on_AttributeContainer_value_changed")
	attribute_label.text = str(attribute_container.name.capitalize(), ":")
	total_label.text = str(attribute_container.get("current"))
	
	var attribute_data : Dictionary = attribute_container.get_data().duplicate(true)
	attribute_data.erase("current")
	
	for i in attribute_data:
		if not typeof(attribute_data[i]) == TYPE_INT and not typeof(attribute_data[i]) == TYPE_REAL:
			continue
		
		var hbox : HBoxContainer = HBoxContainer.new()
		var name_label : Label = Label.new()
		var value_label : Label = Label.new()
		
		hbox.name = i
		name_label.name = "NameLabel"
		name_label.text = str(i.capitalize(), ":")
		name_label.size_flags_horizontal = SIZE_EXPAND_FILL
		value_label.name = "ValueLabel"
		value_label.text = str(attribute_data[i])
		value_label.size_flags_horizontal = SIZE_EXPAND_FILL
		value_label.align = Label.ALIGN_RIGHT
		details_container.add_child(hbox)
		hbox.add_child(name_label)
		hbox.add_child(value_label)


func _set_show_details(value : bool) -> void:
	_show_details = value
	
	if _show_details:
		set_process(true)
		
		if get_node_or_null("Details"):
			remove_child(details)
			owner.add_child(details)
		
		details.rect_global_position = rect_global_position
		details.rect_global_position.y += rect_size.y
		details.rect_size.x = rect_size.x



func _on_AttributeContainer_value_changed(_container_name : String, value_name : String, value_new, value_old) -> void:
	var value_container : HBoxContainer = details_container.get_node_or_null(value_name)
	
	if value_container:
		value_container.get_node("ValueLabel").text = str(value_new)
	
	if value_name == "current":
		total_label.text = str(value_new)


func _on_HoverTimer_timeout() -> void:
	_set_show_details(true)


func _on_mouse_entered() -> void:
	hover_timer.start()


func _on_mouse_exited() -> void:
	if not hover_timer.is_stopped():
		hover_timer.stop()
	elif _show_details:
		_set_show_details(false)
