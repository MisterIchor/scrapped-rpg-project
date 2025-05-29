extends EnhancedObject

var file_manager : FileManager = FileManager.new()
var _containers : Dictionary = {} setget , get_containers

signal requested_value_sent(requester, container_name, value)
signal changed_value_sent(container_name, value_name, data)



func _init() -> void:
	set_name("NewEntity")
	messages.container_exists = ["container with name %s already exists, returning that container instead.", 0]
	messages.no_container_request = ["could not find container %s for requester %s.", 0]
	messages.no_value_found = ["could not find value %s in container %s.", 0]
	messages.container_null = ["found null value in place of container.", 0]
	file_manager.folder_path = "res://assets/saved/containers"
	file_manager.file_type = ".conman"
	file_manager.add_value_to_manage("name", "set_name")
	file_manager.add_value_to_manage("_containers", "_serialize_containers", "_deserialize_containers")
	file_manager.set_owner(self)
	
	if _containers.empty():
		yield(self, "owner_set")
	
	for i in _containers:
		if i == null:
			log_debug(messages.container_null)


func _serialize_containers() -> Dictionary:
	var data_to_serialize : Dictionary = {}
	
	for i in get_containers():
		var data : Dictionary = i.get_data()
		var data_identity : Dictionary = {
			type = "DataContainer",
			script = get_script().resource_path
		}
		
		if i is TemplateContainer:
			data_identity.type = "TemplateContainer"
			data_identity.template = i.template.resource_path
		else:
			data_identity.name = i.name
		
		data_to_serialize[data_identity] = data
	
	return data_to_serialize


func _deserialize_containers(serialized_containers : Dictionary) -> void:
	wipe_containers()
	
	for i in serialized_containers:
		var data : Dictionary = serialized_containers[i]
		var container : DataContainer
		
		match i.type:
			"DataContainer":
				container = add_data_container(i.name, load(i.script))
			"TemplateContainer":
				container = add_template_container(load(i.template), load(i.script))
		
		container.data = data



func add_data_container(container_name : String, container_script : GDScript = null) -> DataContainer:
	if get_container(container_name):
		log_debug(messages.container_exists, [container_name])
		return get_container(container_name)
	
	var new_container : DataContainer = DataContainer.new()
	
	if container_script:
		new_container.set_script(container_script)
		
		if not new_container is DataContainer:
			new_container.free()
			return null
	
	new_container.set_name(container_name)
	new_container.set_owner(self)
	_containers[container_name.to_lower()] = new_container
	return new_container


func add_template_container(template, container_script : GDScript = null):
	var new_container : DataContainer = add_data_container(template.name, container_script)
	
	if new_container:
		new_container.set_template(template)
	
	return new_container


func save_containers() -> void:
	file_manager.save_file(name)


func load_containers(file_name : String) -> void:
	file_manager.load_file(file_name)


func wipe_containers() -> void:
	for i in _containers:
		i.free()



func increment_value_in_container(container_name : String, value_name : String, by : float) -> void:
	var container : DataContainer = get_container(container_name)
	
	if container:
		if container.has_value(value_name):
			container.set(value_name, container.get(value_name) + by)



func set_value_in_container(container_name : String, value_name : String, value) -> void:
	var container : DataContainer = get_container(container_name)
	
	if container:
		if container.has_value(value_name):
			container.set(value_name, value)



func get_container(container_name : String) -> DataContainer:
	return _containers.get(container_name.to_lower())


func get_containers() -> Dictionary:
	return _containers.duplicate()


func get_value_from_container(container_name : String, value_name : String):
	var container : DataContainer = get_container(container_name)
	
	if container:
		return container.get(value_name)
	
	return null



func _on_Container_value_requested(requester : Object, container_requested : String, value_name : String) -> void:
	if not get_container(container_requested):
		log_debug(messages.no_container_request, [container_requested, get_target_name(requester)])
		return
	
	var value = get_value_from_container(container_requested, value_name)
	
	if value == null:
		log_debug(messages.no_value_found, [value, container_requested])
	
	emit_signal("requested_value_sent", requester, value)


func _on_Container_value_changed(container_name : String, value_name : String, value_new, value_old) -> void:
	emit_signal("changed_value_sent", container_name, value_name, value_new, value_old)
