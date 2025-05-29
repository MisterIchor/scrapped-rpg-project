extends Node2D

onready var characters : Node = ($Characters as Node)
onready var tactical_map : Node = ($TacticalMap as Node)



#func _enter_tree() -> void:
#	MusicSystem.set_music_folder("res://assets/music/battle/")


func _ready() -> void:
	for i in characters.get_children():
		i.connect("path_requested", tactical_map, "_on_path_requested")
		i.connect("point_reached", tactical_map, "_on_point_reached", [i])
		tactical_map.connect("path_sent", i, "_on_path_sent")
	
	BattleSystem._set_turn_order(characters.get_list_of_initiatives())
	deploy_characters()



func deploy_characters() -> void:
	var spawn_list : Dictionary = tactical_map.get_spawn_points()
	var chars : Array = characters.get_children()
	
	for i in range(chars.size()):
		var character : Node = chars[i]
		
		character.set_character_position(spawn_list["party"][i])
