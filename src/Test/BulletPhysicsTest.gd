extends Node2D

const Bullet : PackedScene = preload("res://src/Entities/Physical/Items/Weapons/Projectiles/Projectile.tscn")

onready var start_pos : Position2D = ($Position2D as Position2D)
#var weapon : Object = load("res://src/Entities/Items/Weapons/Ranged/Firearm/Firearm.gd").new()



func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		spawn_boolet()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space_bar"):
		spawn_boolet()



func spawn_boolet() -> void:
	var new_bullet : RigidBody2D = Bullet.instance()
	
	new_bullet.set_global_position(start_pos.get_global_position())
	new_bullet.speed = 300
	new_bullet.start_height = 200
	new_bullet.drop_speed = 25
	new_bullet.direction = start_pos.global_position.direction_to(get_global_mouse_position())
	
	for i in $Bullets.get_children():
		new_bullet.add_collision_exception_with(i)
	
	$Bullets.add_child(new_bullet)
	

