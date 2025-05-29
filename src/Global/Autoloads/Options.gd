extends Node

var user_config_save_location : String = "user://config"
var use_advanced_music_system : bool = false
var volume_master : float = 70 setget set_master_volume
var volume_music : float = 100 setget set_music_volume
var volume_voice : float = 100 setget set_voice_volume
var volume_effects : float = 100 setget set_effects_volume
var text_speed : float = 0



func _enter_tree() -> void:
	var directory : Directory = Directory.new()
	
	if not directory.open(user_config_save_location) == OK:
		directory.make_dir(user_config_save_location)
		directory.open(user_config_save_location)
	
	var options : ConfigFile = ConfigFile.new()
	
	if not options.load(get_concatenated_location("options.cfg")) == OK:
		refresh_config()
	
	use_advanced_music_system = options.get_value("Audio", "ams_enabled", false)
	set_master_volume(options.get_value("Audio", "master", 70))
	set_music_volume(options.get_value("Audio", "music", 100))
	set_voice_volume(options.get_value("Audio", "voice", 100))
	set_effects_volume(options.get_value("Audio", "effects", 100))


func _ready() -> void:
	connect("tree_exiting", self, "_on_tree_exiting")



func change_bus_volume(new_volume : float, bus : String) -> void:
	var volume : float = (new_volume - 100) * 0.3 if new_volume > 0 else -99.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), volume)



func has_config_folder() -> bool:
	return ResourceLoader.exists(user_config_save_location)


func has_user_config_file(file_name : String) -> bool:
	return ResourceLoader.exists(get_concatenated_location(file_name), ".cfg")


func refresh_config() -> void:
	var options : ConfigFile = ConfigFile.new()
	var file : File = File.new()
	
	file.open(get_concatenated_location("options.cfg"), File.WRITE)
	file.close()
	
	options.load(get_concatenated_location("options.cfg"))
	options.set_value("Audio", "ams_enabled", false)
	options.set_value("Audio", "master", 70)
	options.set_value("Audio", "music", 100)
	options.set_value("Audio", "voice", 100)
	options.set_value("Audio", "effects", 100)
	options.save(get_concatenated_location("options.cfg"))


func save_config() -> void:
	var options : ConfigFile = ConfigFile.new()
	
	if not options.load(get_concatenated_location("options.cfg")):
		return
	
	options.set_value("Audio", "ams_enabled", use_advanced_music_system)
	options.set_value("Audio", "master", volume_master)
	options.set_value("Audio", "music", volume_music)
	options.set_value("Audio", "voice", volume_voice)
	options.set_value("Audio", "effects", volume_effects)
	options.save(get_concatenated_location("options.cfg"))



func set_master_volume(new_volume : float) -> void:
	volume_master = new_volume
	change_bus_volume(volume_master, "Master")


func set_music_volume(new_volume : float) -> void:
	volume_music = new_volume
	change_bus_volume(volume_music, "Music")


func set_voice_volume(new_volume : float) -> void:
	volume_voice = new_volume
	change_bus_volume(volume_voice, "Voice")


func set_effects_volume(new_volume : float) -> void:
	volume_effects = new_volume
	change_bus_volume(volume_effects, "Effects")



func get_concatenated_location(file_name : String) -> String:
	return user_config_save_location + "/" + file_name



func _on_tree_exiting() -> void:
	save_config()
