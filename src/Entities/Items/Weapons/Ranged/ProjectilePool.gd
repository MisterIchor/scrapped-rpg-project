extends Node

signal new_projectile_added(projectile)

const ProjectileBody : PackedScene = preload("res://src/Entities/Items/Weapons/Projectiles/Projectile.tscn")

var template : ProjectileTemplate = null
var max_projectiles : int = 0
var available_projectiles : Array = []



func _create_projectile() -> void:
	var new_projectile : RigidBody2D = ProjectileBody.instance()
	
	new_projectile.set_template(template)
	add_child(new_projectile)
	connect("new_projectile_added", new_projectile, "_on_new_projectile_added")
	new_projectile.connect("hit", self, "_on_Projectile_hit", [new_projectile])
	available_projectiles.append(new_projectile)
	emit_signal("new_projectile_added", new_projectile)



func get_next_available_projectile() -> Projectile:
	var next_projectile : Projectile = available_projectiles.pop_back()
	
	if not next_projectile:
		_create_projectile()
		next_projectile = available_projectiles.pop_back()
	
	return next_projectile



func _on_Projectile_hit(projectile : Projectile) -> void:
	if get_child_count() > max_projectiles:
		projectile.queue_free()
	else:
		projectile.set_active(false)
		available_projectiles.append(projectile)
