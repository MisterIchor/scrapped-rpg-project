tool
extends Node

var catagory : Dictionary = {
	debug = [],
	general = [],
	combat = [],
	loot = [],
}
var debug_level : int = 1

signal catagory_added(catagory_name)
signal log_written(catagory_name, text, time)



func _init() -> void:
	set_pause_mode(Node.PAUSE_MODE_PROCESS)


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	write_to_log("general", "Sharashka yawns.")
	yield(get_tree().create_timer(1.0), "timeout")
	write_to_log("combat", "William stubs his toe and loses 10 HP.")
	yield(get_tree().create_timer(1.0), "timeout")
	write_to_log("loot", "While yawning, Sharashka coughs up a diamond he ate earlier.")
#	ConsoleSystem.add_to_console(self)



func add_catagory(new_catagory : String) -> void:
	if not catagory.has(new_catagory):
		catagory[new_catagory] = []
		emit_signal("catagory_added", new_catagory)
	else:
		write_to_debug(str("LogSystem: Log catagory ", new_catagory, " already exists."), 1)


func write_to_debug(text : String, level : int) -> void:
	if level > debug_level:
		return
	
	write_to_log("debug", text)


func write_to_log(log_catagory : String, text : String) -> void:
#	yield(get_tree(), "idle_frame")
	if catagory.has(log_catagory):
		catagory[log_catagory].append([text, get_time_formatted()])
		emit_signal("log_written", log_catagory, text, get_time_formatted())
	else:
		write_to_debug(str("Attempted to write to non-existent log ", log_catagory), 1)
	
	if log_catagory == "debug" and OS.is_debug_build():
		print(get_time_formatted(), " ", text)



func dump_logs() -> void:
	var dir : Directory = Directory.new()
	
	if dir.open("res://src/Logs/") == OK:
		for i in catagory:
			var file : File = File.new()
			file.open(str(dir.get_current_dir(), "/", i), File.WRITE)
			
			for j in catagory[i]:
				var text : String = str(j[1], " ", j[0])
				file.store_line(text)
			
			file.close()



static func get_time_formatted(use_twelve_hour_time : bool = false) -> String:
	var time : Dictionary = OS.get_time()
	var period : String = ""
	
	if use_twelve_hour_time:
		if time.hour > 12:
			time.hour -= 12
		
		if time.hour == 0:
			time.hour = 12
	
	for i in time:
		if time[i] <= 9:
			time[i] = str("0", time[i])
	
	return str("(", time.hour, ":", time.minute, ":", time.second, ")")
