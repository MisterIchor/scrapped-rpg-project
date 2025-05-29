extends YSort

const Body : PackedScene = preload("res://src/Entities/Character/Tactical/Body/Body.tscn")



func _ready() -> void:
	for i in PartySystem.get_children():
		var new_body : Node = Body.instance()
		
		new_body.set_soul(i)
		add_child(new_body)



func get_list_of_initiatives() -> Array:
	var initiative_list : Array = []
	
	for i in get_children():
		var character : Node = i.soul
		
#		initiative_list.append([character, character.get_initiative()])
	
	return initiative_list
