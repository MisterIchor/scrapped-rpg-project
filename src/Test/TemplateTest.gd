extends Node2D

var test : DataContainerTemplate = preload("res://src/Resources/Items/Weapons/Ranged/Peestol.tres")
var template : Object = preload("res://src/Entities/Physical/Items/Item.gd").new()



func _ready() -> void:
	template.set_template(test)
