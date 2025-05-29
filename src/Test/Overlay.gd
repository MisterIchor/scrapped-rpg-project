tool
extends Control
class_name Overlay

export (String, "PARENT", "SCREEN") var type : String setget set_type
export (Texture) var texture : Texture = null setget set_texture



func set_type(new_type : String) -> void:
	type = new_type
	
	match type:
		"PARENT":
			if not is_inside_tree():
				yield(self, "ready")
				
				if not get_parent() is TextureRect:
					print("ya fucked up")
					return
				
				set_texture(get_parent().texture)


func set_texture(new_texture : Texture) -> void:
	texture = new_texture
	material.set_shader_param("test", texture)
