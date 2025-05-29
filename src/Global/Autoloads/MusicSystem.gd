extends AudioStreamPlayer

var current_song : AudioStreamOGGVorbis = null setget set_current_song
var music_folder : String = ""
var song_list : Array = []
var loop_song : bool = false
var pause_between_songs : float = 0.05



func _init() -> void:
	set_bus("Music")


func _enter_tree() -> void:
#	set_music_folder("res://assets/music/travel/")
	connect("finished", self, "_on_finished")


#func _ready() -> void:
#	BattleSystem.connect("battle_started", self, "_on_BattleSystem_battle_started")
#	BattleSystem.connect("battle_finished", self, "_on_BattleSystem_battle_finished")



func play_song(song_dir : String) -> void:
	if not song_dir.is_abs_path():
		LogSystem.write_to_debug(str(name, ": ", song_dir, " is not an absolute path."), 1)
		return
	
	var song : AudioStreamOGGVorbis = load(song_dir)
	
	if not song:
		LogSystem.write_to_debug(str(name, ": could not load song from path", song_dir), 1)
		return
	
	set_current_song(song)


func play_song_from_list(song_name : String) -> void:
	for i in song_list:
		if i.get_name() == song_name:
			set_current_song(i)
			return
	
	LogSystem.write_to_debug(str(name, ": could not find '", song_name, "' in list from folder ", music_folder), 1)


func play_next_song() -> void:
	song_list.push_back(song_list.pop_front())
	set_current_song(song_list.front())


func shuffle_song_list() -> void:
	song_list.shuffle()


func scan_folder_for_music(folder : String) -> void:
	var new_folder : Directory = Directory.new()
	
	if not new_folder.open(folder) == OK:
		LogSystem.write_to_debug(str(name, ": error opening music folder at path ", folder), 1)
		return
	
	new_folder.list_dir_begin()
	song_list.clear()
	
	var current_file : String = new_folder.get_next()
	
	while not current_file.empty():
		if current_file.ends_with(".import") or new_folder.current_is_dir():
			current_file = new_folder.get_next()
			continue
		
		var file : Resource = load(new_folder.get_current_dir() + "/" + current_file)
		
		if file is AudioStreamOGGVorbis:
			file.set_name(current_file.format([""], str(".", current_file.get_extension())))
			song_list.append(file)
		
		current_file = new_folder.get_next()
	
	new_folder.list_dir_end()



func set_current_song(new_song : AudioStreamOGGVorbis) -> void:
	stop()
	current_song = new_song
	set_stream(current_song)
	yield(get_tree().create_timer(pause_between_songs), "timeout")
	play()


func set_music_folder(folder_path : String) -> void:
	music_folder = folder_path
	scan_folder_for_music(music_folder)
	shuffle_song_list()
	set_current_song(song_list.front())


func set_pitch(percentage : int) -> void:
	set_pitch_scale(percentage * 0.01)


func set_volume(percentage : int) -> void:
	set_volume_db((percentage - 100) * 0.3)



func _on_dialogue_changed(answer : AnswerTemplate, next_dialogue : DialogueTemplate) -> void:
	if next_dialogue.music.song:
		set_volume(next_dialogue.music.volume)
		set_pitch(next_dialogue.music.pitch)
		set_current_song(next_dialogue.music.song)


func _on_finished() -> void:
	play_next_song() if not loop_song else play()


func _on_BattleSystem_battle_started() -> void:
	set_music_folder("res://assets/music/battle/")


func _on_BattleSystem_battle_finished() -> void:
	set_music_folder("res://assets/music/travel/")
