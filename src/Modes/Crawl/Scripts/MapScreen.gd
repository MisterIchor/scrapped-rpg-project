extends Control

enum MapType {CAVE, FORT, DUNGEON}
enum MapSize {BIG, MEDIUM, SMALL, TINY, CUSTOM}
enum MapInten {SWARMING, HIGH, MEDIUM, LOW, BARREN}
enum MapDiff {EXTREME, HARD, NORMAL, EASY, BEGINNER}

var type : int = 0 setget set_map_type
var size = 0 setget set_map_size
var intensity : int = 0 setget set_map_intensity
var difficulty : int = 0 setget set_map_difficulty

onready var generator : Node = ($MapGenerator as Node)
onready var tilemap : TileMap = ($MapTileset as TileMap)


func _ready() -> void:
	set_map_type(MapType.CAVE)
	set_map_size(MapSize.BIG)
	set_map_intensity(MapInten.SWARMING)
	set_map_difficulty(MapDiff.EXTREME)
	randomize()


func _on_GenerateButton_pressed() -> void:
	var rooms : Array = generator.generate_rooms()
	tilemap.create_map_from_tiles(rooms)

func _on_MapType_selected(ID : int) -> void:
	set_map_type(ID)

func _on_MapSize_selected(ID : int) -> void:
	set_map_size(ID)

func _on_MapIntensity_selected(ID : int) -> void:
	set_map_intensity(ID)

func _on_MapDifficulty_selected(ID : int) -> void:
	set_map_difficulty(ID)


func set_map_type(new_type : int) -> void:
	type = new_type
	match type:
		MapType.CAVE:
			generator.map_type_modifier = 0.5
		MapType.FORT:
			generator.map_type_modifier = 1
		MapType.DUNGEON:
			generator.map_type_modifier = 0.75

func set_map_size(new_size) -> void:
	match typeof(new_size):
		TYPE_VECTOR2:
			generator.map_size = new_size
			size = MapSize.CUSTOM
		TYPE_INT:
			size = new_size
			match size:
				MapSize.BIG:
					generator.map_size = Vector2(18,9)
					generator.set_room_settings(30, 50)
				MapSize.MEDIUM:
					generator.map_size = Vector2(13, 6)
					generator.set_room_settings(20, 35)
				MapSize.SMALL:
					generator.map_size = Vector2(11,4)
					generator.set_room_settings(8, 18)
				MapSize.TINY:
					generator.map_size = Vector2(8,4)
					generator.set_room_settings(4, 12)
		_:
			push_error("Error: Attempted to set invalid type for map_size")

func set_map_intensity(new_intensity : int) -> void:
	intensity = new_intensity
	match intensity:
		MapInten.SWARMING:
			generator.set_enc_settings(5, 10, 40)
		MapInten.HIGH:
			generator.set_enc_settings(4, 8, 25)
		MapInten.MEDIUM:
			generator.set_enc_settings(3, 6, 15)
		MapInten.LOW:
			generator.set_enc_settings(2, 4, 7)
		MapInten.BARREN:
			generator.set_enc_settings(0, 1, 3)

func set_map_difficulty(new_difficulty) -> void:
	difficulty = new_difficulty
