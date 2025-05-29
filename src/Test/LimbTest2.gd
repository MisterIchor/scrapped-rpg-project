tool
extends Node2D

var item_data = load("res://src/Entities/Physical/Items/Weapons/Ranged/Firearm/Firearm.gd").new()
onready var item_body : KinematicBody2D = ($RangedWeaponBody as KinematicBody2D)
onready var hand : KinematicBody2D = ($Limb/LimbSection3 as KinematicBody2D)



func _ready() -> void:
	item_data.set_template(load("res://src/Resources/Items/Weapons/Ranged/Peestol.tres"))
	item_body.set_data(item_data)
	hand.set_equipped_item(item_body)

