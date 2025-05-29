extends Node

var RoomSettings : Dictionary = {
	min = -1,
	max = -1,
	amount = 0,
}

var EncSettings : Dictionary = {
	min = -1,
	max = -1,
	amount = 0,
	def_chance = 0,
	cur_chance = 0
}

var map_type_modifier : float = 1
var map_size : Vector2
var tiles : Array = []


func set_enc_settings(min_enc : int, max_enc : int, enc_chance : float) -> void:
		EncSettings.min = min_enc
		EncSettings.max = max_enc
		EncSettings.def_chance = enc_chance

func set_room_settings(min_rooms : int, max_rooms : int) -> void:
	RoomSettings.min = min_rooms
	RoomSettings.max = max_rooms


func determine_enc() -> bool:
	if EncSettings.amount < EncSettings.max:
		if rand_range(0, 100) <= EncSettings.cur_chance:
			EncSettings.amount += 1
			EncSettings.cur_chance -= EncSettings.cur_chance * 0.1
			return true
	return false

func set_hallway(value : bool) -> bool:
	if value:
		return true
	RoomSettings.amount += 1
	return false

func select_rand_tile() -> Vector2:
	var a : Vector2 = Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	for i in tiles:
		var pos : Vector2 = i[0]
		if a == pos:
			a = select_rand_tile()
	
	return a

func create_room(coord : Vector2, is_hallway : bool = false) -> void:
	var room : Array = []
	
	room.append(coord)
	room.append(determine_enc())
	room.append(set_hallway(is_hallway))
	
	tiles.append(room)

func generate_rooms() -> Array:
	var _room : Vector2 = Vector2(-1, -1)
	var _extra_rooms : int = randi() % (RoomSettings.max - RoomSettings.min) * map_type_modifier
	RoomSettings.amount = 0
	EncSettings.amount = 0
	EncSettings.cur_chance = EncSettings.def_chance
	tiles.clear()
	
	if RoomSettings.min != -1:
		while RoomSettings.amount < RoomSettings.min * map_type_modifier:
			_room = select_rand_tile()
			create_room(_room)
	
	for i in range(_extra_rooms):
		_room = select_rand_tile()
		create_room(_room)

	return tiles
