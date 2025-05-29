extends Node

const Body : PackedScene = preload("res://src/Entities/Physical/Character/Tactical/Body/Body.tscn")



func _enter_tree() -> void:
	for i in PartySystem.get_party_members():
		var new_body : UnitBody = Body.instance()
		
		new_body.set_soul(i)
		add_child(new_body)
