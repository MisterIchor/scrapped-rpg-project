extends Node2D

const HairSection : GDScript = preload("res://src/Test/HairSection.gd")

export (float, 0.1, 1.0, 0.1) var loose_hair_percentage : float = 0.1
export (Texture) var hair_texture : Texture setget set_hair_texture
export (float) var sway : float = 0.0 setget set_sway

var count : float = 0.0



func _process(delta: float) -> void:
	count += delta
	set_sway(sin(count))



func set_hair_texture(new_texture : Texture) -> void:
	hair_texture = new_texture
	
	if not hair_texture:
		return
	
	var texture_size : Vector2 = hair_texture.get_size()
	var image_data : Image = hair_texture.get_data()
	var data_array : Array = []
	
	for i in get_children():
		i.queue_free()
	
	for i in texture_size.y * loose_hair_percentage:
		var cropped_data : Image = Image.new()
		
		cropped_data.create_from_data(image_data.get_width(), image_data.get_height(), 
				image_data.has_mipmaps(), image_data.get_format(), image_data.get_data())
		cropped_data.flip_y()
		cropped_data.crop(texture_size.x, 1)
		cropped_data.flip_y()
		data_array.append(cropped_data)
		image_data.crop(texture_size.x, texture_size.y - (i + 1))
	
	data_array.invert()
	
	for i in data_array.size():
		var texture : ImageTexture = ImageTexture.new()
		var new_section : Sprite = Sprite.new()
		
		texture.create_from_image(data_array[i], 0)
		new_section.set_script(HairSection)
		new_section.z_as_relative = true
		new_section.z_index = -i
		new_section.texture = texture
		add_child(new_section)


func set_sway(new_sway : float) -> void:
	sway = new_sway

	if not hair_texture:
		return
	
	var children : Array = get_children()
	children.invert()
	
	for i in children:
		var texture_size : Vector2 = i.texture.get_size()
		var child_pos : int = i.get_position_in_parent()
		var mod : float = ((child_pos + 1) / float(children.size())) * sway
		
		i.position.x = (texture_size.x / 4.0) * sin(mod)
		i.position.y = abs(texture_size.y * cos(mod))
		i.position.y += texture_size.y * -abs(child_pos * mod) + child_pos
