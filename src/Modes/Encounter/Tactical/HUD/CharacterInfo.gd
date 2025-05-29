extends VBoxContainer

export (PoolStringArray) var containers : PoolStringArray

var added_containers : Dictionary = {}
var soul : Soul = null setget set_soul
var parser : Parser = Parser.new(self, String(), "res://src/Global/Parser/Instructions/CharacterInfoInstructions.gd")



func _ready() -> void:
	for i in containers:
		var data : Array = i.split(" ")
		var container_name : String = data.pop_front()
		
		add_container_info(container_name, data)



#func animate_stat(label :)


func add_container_info(container_name : String, data : PoolStringArray) -> void:
	if not soul:
		yield(get_tree(), "idle_frame")
	
	added_containers[container_name] = data
	add_label(container_name, get_container_info(container_name, data))



func add_label(label_name : String, text : String) -> void:
	var new_label : Label = Label.new()
	
	new_label.set_name(label_name)
	new_label.set_text(text)
	add_child(new_label)


func get_container_info(container_name : String, data : PoolStringArray) -> String:
	var container : DataContainer = soul.get_container(container_name)
	var text : String = container_name.capitalize() + ": "
	
	if not container:
		return "Container not found: " + container_name
	
	for i in data:
		text += str(container.get(i))
		
		if not data[-1] == i:
			text += "/"
	
	return text


func update_hud() -> void:
	for i in get_children():
		i.set_text(get_container_info(i.get_name(), added_containers[i.get_name()]))



func set_soul(new_soul : Soul) -> void:
	if soul:
		soul.disconnect("selection_changed", self, "_on_Soul_selection_changed")
		soul.disconnect("changed_value_sent", self, "_on_Soul_changed_value_sent")
	
	soul = new_soul
	soul.connect("selection_changed", self, "_on_Soul_selection_changed")
	soul.connect("changed_value_sent", self, "_on_Soul_changed_value_sent")
	update_hud()



func _on_Soul_changed_value_sent(_container_name : String, _value_name : String, _value) -> void:
	update_hud()


func _on_Soul_type_changed(type : String) -> void:
	return
