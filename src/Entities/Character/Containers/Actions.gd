	extends DataContainer



func _init() -> void:
	add_value("cautious approach", load("res://src/Resources/Actions/CautiousApproach.tres"))
	add_value("shoot and scoot", load("res://src/Resources/Actions/ShootAndScoot.tres"))
	add_value("move", load("res://src/Resources/Actions/Move.tres"))

#func _set(property: String, value) -> bool:
