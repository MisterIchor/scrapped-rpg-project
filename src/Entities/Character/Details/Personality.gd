extends DataContainer



func _init():
	add_value("traits", [])
	add_value("sanguine", 0)
	add_value("choleric", 0)
	add_value("melancholic", 0)
	add_value("phlegmatic", 0)



func set_traits(new_traits : Array) -> void:
	_set_value("traits", new_traits)	



func get_traits() -> Array:
	return _get_value("traits")
