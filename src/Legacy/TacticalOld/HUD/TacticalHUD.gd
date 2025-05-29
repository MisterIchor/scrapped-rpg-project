extends Control

const CharacterInfo : PackedScene = preload("res://src/Modes/Encounter/Tactical/HUD/CharacterInfo.tscn")



func _ready() -> void:
	for i in PartySystem.get_children():
		var info_hud : VBoxContainer = CharacterInfo.instance()
		
		$Stats.add_child(info_hud)
		info_hud.set_soul(i)
