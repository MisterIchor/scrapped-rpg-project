extends Node

const DefaultSeeds : Array = [
	"ShaWasHere", 
	"MisterIchorSendsHisRegards", 
	"ThereWasAHoleHere",
	"PassTheWhiskey",
	"INEEDAMEDICBAG",
	"Ispeelmydrink!",
	"Heyyouseemygun?",
]
var _RNG : RandomNumberGenerator = RandomNumberGenerator.new()
var _seed : String = "" setget set_seed



func roll(modifier : int = 0) -> int:
	var result : int = 0
	
	result = (_RNG.randi_range(1, 100)) + modifier
	print(result)
	return result


func roll_advantage(modifier : int = 0, times_to_roll : int = 1) -> int:
	var result : int = 0
	
	for _i in times_to_roll:
		result = max(result, roll(modifier))
	
	return result


func roll_disadvantage(modifier : int = 0, times_to_roll : int = 1) -> int:
	var result : int = 0
	
	for _i in times_to_roll:
		result = min(result, roll(modifier))
	
	return result



func set_seed(new_seed : String) -> void:
	_seed = new_seed
	_RNG.seed = hash(new_seed)
