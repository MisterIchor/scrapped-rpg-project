tool
extends Node2D

#enum array_test {E, A, SPORTS}
var array_test : PoolStringArray = [
	"E",
	"A",
	"Sports",
	"It's in the game",
	"binch"
]
var selected : String = String()


func _ready() -> void:
	print(get("test"))


func _set(property: String, value) -> bool:
	prints(property, value, typeof(get(property)))

	if property == "test":
		selected = value
		return true

	return true


func _get(property: String):
	if property == "test":
		return selected


func _get_property_list() -> Array:
	var properties = []
	
	properties.append({
			name = "Rotate",
			type = TYPE_NIL,
			hint_string = "rotate_",
			usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	properties.append({
		name = "rotate_speed",
		type = TYPE_INT,
		value = 1
	})
	
	properties.append({
		name = "test",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = array_test.join(",")
	})
	
	return properties


func _on_draw() -> void: 
	return




