extends Resource
class_name ProjectileTemplate

export (Texture) var sprite : Texture
export (String, FILE, "*.coldata") var collision_data : String = ""
export (float) var start_speed : float = 1000
export (float) var drop_speed : float = 3
export (int, 1, 999) var number_of_projectiles : int = 1
export (int) var damage : int = 0
