extends Node2D

var shots_fired : int = 0
var intersept : int = 0
var global_height : int = 0
var item_data = load("res://src/Entities/Items/Weapons/Ranged/Firearm/Firearm.gd").new()
onready var item_body : BaseBody = ($RangedWeaponBody as RigidBody2D)



func _ready() -> void:
	item_data.set_template(load("res://src/Resources/Items/Weapons/Ranged/Peestol.tres"))
	item_body.set_container(item_data)
	item_body.global_height = 150
	item_body.height = 10
	item_body.connect("projectile_fired", self, "_on_projectile_fired")
#	Engine.time_scale 
	item_body.get_node("ProjectilePool").connect("new_projectile_added", self, "_on_new_projectile_added")


func _on_Projectile_hit(projectile : Projectile) -> void:
	VisualServer.canvas_item_add_circle($Draw.get_canvas_item(), projectile.global_position, 2, Color.red - Color(0, 0, 0, 0.25))
	
#	if projectile.global_height <= 0:
#		global_height += 1
#		$Camera2D/CanvasLayer/GlobalHeightHits.text = str("Global Height: ", global_height)
#	else:
#		intersept += 1
#		$Camera2D/CanvasLayer/HeightinterseptHits.text = str("Height intersept: ", intersept)


func _on_new_projectile_added(projectile : Projectile) -> void:
	projectile.connect("hit", self, "_on_Projectile_hit", [projectile])
	projectile.connect("height_intercept", self, "_on_height_intercept", [projectile])
	projectile.connect("global_height", self, "_on_global_height", [projectile])



func _input(event : InputEvent) -> void:
	if Input.is_key_pressed(KEY_DOWN):
		$Camera2D.current = !$Camera2D.current



func _process(delta: float) -> void:
	if Input.is_action_pressed("select"):
		item_body.fire_projectile()



func _on_projectile_fired(ammo_left : int) -> void:
	shots_fired += 1
	$Camera2D/CanvasLayer/ShotsFired.text = str("Shots Fired: ", shots_fired)


func _on_height_intercept(projectile : Projectile) -> void:
	intersept += 1
	$Camera2D/CanvasLayer/HeightIntersectHits.text = str("Height Intercept: ", intersept)
	VisualServer.canvas_item_add_rect($Draw.get_canvas_item(), Rect2(projectile.position - Vector2(3, 3), Vector2(6, 6)), Color.royalblue)

func _on_global_height(projectile : Projectile) -> void:
	global_height += 1
	$Camera2D/CanvasLayer/GlobalHeightHits.text = str("Global Height: ", global_height)
	VisualServer.canvas_item_add_circle($Draw.get_canvas_item(), projectile.global_position, 2, Color.black - Color(0, 0, 0, 0.25))
