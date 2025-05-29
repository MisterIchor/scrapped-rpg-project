extends Node2D
var test = load("res://src/Global/EnhancedObject.gd").new()

func _ready() -> void:
	var e = test.get_script_property_list()
	breakpoint
