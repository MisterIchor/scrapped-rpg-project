tool
extends EnhancedObject
class_name FileManager

const BACKUP : String = "res://assets/saved/backup"

var object_to_manage : Object = null
var values_to_manage : Array = []
var file_type : String = ".undefined"
var folder_path : String = BACKUP



func _init() -> void:
	set_name("FileManager")
	messages.failed_to_open_file = ["Failed to open file, returned %s.", 1]
	messages.failed_to_make_dir = ["Could not create path for file, resorting to backup...", 1]
	messages.saved_successfully = ["File %s saved at path %s.", 2]
	messages.loaded_successfully = ["File %s at path %s loaded successfully.", 2]
	messages.wrong_file_type = ["Wrong file type provided (%s vs %s)", 0]


func _notification(what: int) -> void:
	if what == NOTIFICATION_OWNER_SET:
		var dir : Directory = Directory.new()
		
		if not dir.open(folder_path) == OK:
			if not dir.make_dir_recursive(folder_path) == OK:
				log_debug(messages.failed_to_make_dir)
				folder_path = BACKUP
		
		set_name(owner.name + "FileManager")



func _process_file(file_name : String, read_flag : int) -> File:
	var file : File = File.new()
	
	if not file_name.get_extension():
		file_name += file_type
	elif not str(".", file_name.get_extension()) == file_type:
		log_debug(messages.wrong_file_type, [file_type, file_name.get_extension()])
		return file
	
	var error_code : int = file.open(folder_path.plus_file(file_name), read_flag)
	
	if not error_code == OK:
		log_debug(messages.failed_to_open_file, [error_code])
	
	if Engine.editor_hint:
		EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
	
	return file



func add_value_to_manage(value_name : String, setter_name : String = String(), getter_name : String = String()) -> void:
	for i in values_to_manage:
		if i.value_name == value_name:
			return
	
	values_to_manage.append({
		value_name = value_name,
		setter = setter_name,
		getter = getter_name
	})


func save_file(file_name : String) -> void:
	var file : File = _process_file(file_name, File.WRITE)
	
	if file.is_open():
		for i in values_to_manage:
			if object_to_manage.has_method(i.getter):
				file.store_var(object_to_manage.call(i.getter))
			else:
				file.store_var(object_to_manage.get(i.value_name))
		
		log_debug(messages.saved_successfully, [file_name, folder_path])
	
	file.close()


func load_file(file_name : String) -> void:
	var file : File = _process_file(file_name, File.READ)
	
	if file.is_open():
		for i in values_to_manage:
			var value = file.get_var()
			
			if object_to_manage.has_method(i.setter):
				object_to_manage.call(i.setter, value)
			else:
				object_to_manage.set(i.value_name, value)
		
		log_debug(messages.loaded_successfully, [file_name, folder_path])
	
	file.close()



#func set_folder_path(new_path : String) -> void:
#	folder_path = new_path
#
#	var dir : Directory = Directory.new()
#
#	if not dir.dir_exists(folder_path):
#		dir.make_dir_recursive(folder_path)
