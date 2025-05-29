tool
extends CatagoryTemplate
class_name BaseBodyTemplate

export (int) var health_base : int = 30
export (int) var defense_base : int = 0
export (Texture) var sprite : Texture = preload("res://assets/graphics/limbs/circle.png")
export (String, FILE) var collision_data : String = String()
export (Dictionary) var sound_bank : Dictionary = {} setget set_sound_bank

var _body : PackedScene = preload("res://src/Entities/BaseBody.tscn")



func _init() -> void:
	add_bank("destroyed")
	add_bank("damaged")
	add_bank("impact_blunt")
	add_bank("impact_slash")
	add_bank("impact_pierce")



func add_bank(bank_name : String) -> void:
	if not sound_bank.get(bank_name):
		sound_bank[bank_name] = []


func create_body() -> BaseBody:
	return (_body.instance() as BaseBody)



func set_sound_bank(new_dictionary : Dictionary) -> void:
	sound_bank = new_dictionary
	
	if Engine.editor_hint:
		for i in sound_bank:
			for j in range(sound_bank[i].size()):
				if not sound_bank[i][j]:
					sound_bank[i][j] = Resource.new()
