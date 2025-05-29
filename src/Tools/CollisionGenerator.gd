tool
extends BaseBody

signal pixel_data_update

export (float, 0.001, 1) var transparency_bias : float = 0.1 setget set_transparency_bias

var sprite_texture : Texture setget set_sprite_texture
var pixel_data : PoolVector2Array = [] setget set_pixel_data
var col_scale : Vector2 = Vector2.ONE setget set_col_scale
var sprite_scale : Vector2 = Vector2.ONE setget set_sprite_scale
var pos_adjustment : Vector2 = Vector2(0.5, 0.5)
var interp : Dictionary = {
	enable = false,
	iterations = 0,
}
var collision_name : String = ""



func _init() -> void:
	connect("collision_update", self, "_on_collision_update")
	connect("pixel_data_update", self, "_on_pixel_data_update")


func _ready() -> void:
	sprite.connect("texture_changed", self, "_on_Sprite_texture_changed")



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "col_height",
		type = TYPE_REAL
	})
	
	property_list.append({
		name = "ExportCollisionData",
		type = TYPE_NIL,
		hint_string = "exportcol_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "exportcol_name",
		type = TYPE_STRING
	})
	
	property_list.append({
		name = "exportcol_save",
		type = TYPE_BOOL
	})
	
	
	property_list.append({
		name = "PositionAdjustment",
		type = TYPE_NIL,
		hint_string = "posad_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "posad_x",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,1,0.001,or_greater,or_lesser"
	})
	
	property_list.append({
		name = "posad_y",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,1,0.001,or_greater,or_lesser"
	})
	
	
	property_list.append({
		name = "CollisionScale",
		type = TYPE_NIL,
		hint_string = "colscale_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "colscale_x",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0.5,2,0.001,or_greater,or_lesser"
	})
	
	property_list.append({
		name = "colscale_y",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0.5,2,0.001,or_greater,or_lesser"
	})
	
	
	property_list.append({
		name = "CollisionInterpolation",
		type = TYPE_NIL,
		hint_string = "colinterp_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	property_list.append({
		name = "colinterp_enable",
		type = TYPE_BOOL,
	})
	
	property_list.append({
		name = "colinterp_iterations",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,50,or_greater"
	})
	
	return property_list


func _set(property: String, value) -> bool:
	if property == "col_height":
		height = value
	
	if property == "exportcol_name":
		collision_name = value
	
	if property == "exportcol_save":
		if value:
			save_collision_data()
	
	if property == "posad_x":
		pos_adjustment.x = value
	
	if property == "posad_y":
		pos_adjustment.y = value
	
	if property == "colscale_x":
		col_scale.x = value
	
	if property == "colscale_y":
		col_scale.y = value
	
	if property == "colinterp_enable":
		interp.enable = value
	
	if property == "colinterp_iterations":
		interp.iterations = value
	
	emit_signal("collision_update")
	return false


func _get(property: String):
	if property == "col_height":
		return height
	
	if property == "exportcol_name":
		return collision_name
	
	if property == "posad_x":
		return pos_adjustment.x
	
	if property == "posad_y":
		return pos_adjustment.y
	
	if property == "colscale_x":
		return col_scale.x
	
	if property == "colscale_y":
		return col_scale.y
	
	if property == "colinterp_enable":
		return interp.enable
	
	if property == "colinterp_iterations":
		return interp.iterations



func save_collision_data() -> void:
	file_manager.save_file(collision_name)



func set_transparency_bias(new_bias : float) -> void:
	transparency_bias = new_bias
	emit_signal("collision_update")



func optimize_boundaries(boundaries : Array) -> PoolVector2Array:
	var optimized_array : PoolVector2Array = []
	var section : PoolVector2Array = []
	var y : float = -99999.999
	
	for i in boundaries:
		if y == -99999.999:
			y = i.y
		
		if i.y == y:
			section.append(i)
		else:
			optimized_array.append(section[0])
			optimized_array.append(section[-1])
			section = []
			y = -99999.999
	
	return optimized_array




func interpolate_boundary(boundary_array : PoolVector2Array, iterations : int) -> PoolVector2Array:
	var interp_boundary : PoolVector2Array = boundary_array
	
	for i in range(iterations):
		var interp_line : Array = []
		var points_to_remove : PoolVector2Array = []
		var invert : bool = false
		
		for j in range(1, interp_boundary.size()):
			var point : Dictionary = {
			start = interp_boundary[j - 1],
			end = interp_boundary[j],
		}
			interp_line.append(point.start)
			interp_line.append(get_body_midpoint(point.start, point.end))
			points_to_remove.append(point.end)
		
		for j in points_to_remove:
			if j in interp_line:
				interp_line.erase(j)
		
		interp_line[0] = get_body_midpoint(interp_boundary[0], interp_boundary[-1])
		interp_boundary = PoolVector2Array(interp_line)
	
	return interp_boundary



func set_sprite_texture(new_texture : Texture) -> void:
	sprite_texture = new_texture
	sprite.set_texture(sprite_texture)
	emit_signal("collision_update")


func set_collision_data(new_data : PoolVector2Array	) -> void:
	.set_collision_data(new_data)
	emit_signal("collision_update")


func set_col_scale(new_scale : Vector2) -> void:
	col_scale = new_scale
	emit_signal("collision_update")


func set_sprite_scale(new_scale : Vector2) -> void:
	sprite_scale = new_scale
	sprite.set_scale(sprite_scale)
	emit_signal("collision_update")


func set_pixel_data(new_data : PoolVector2Array) -> void:
	pixel_data = new_data
	emit_signal("collision_update")



func get_pixel_data(pos_adjustment : Vector2, transparency_bias : float) -> PoolVector2Array:
	var data : PoolVector2Array = PoolVector2Array()
	var image : Image = sprite.texture.get_data()
	
	image.lock()
	
	for x in image.get_width():
		for y in image.get_height():
			var color : Color = image.get_pixel(x, y)
			
			if color.a >= transparency_bias:
				var pixel_pos : Vector2 = Vector2(x, y)
				
				pixel_pos += pos_adjustment
				pixel_pos -= image.get_size() / 2
				pixel_pos *= col_scale
				pixel_pos *= sprite.scale
				data.append(pixel_pos)
	
	image.unlock()
	return data


func get_boundaries() -> PoolVector2Array:
	var boundaries : Dictionary = {
		top = [],
		bottom = []
	}
	var collumns : Dictionary = {}
	
	for i in pixel_data:
		if not i.x in collumns:
			collumns[i.x] = []
		
		collumns[i.x].append(i)
	
	for i in collumns:
		boundaries.top.append(collumns[i].front())
		boundaries.bottom.append(collumns[i].back())
	
	var boundary_array : PoolVector2Array = boundaries.top
	
	boundaries.bottom.invert()
	boundary_array.append_array(boundaries.bottom)
	
	return boundary_array



func _on_pixel_data_update() -> void:
	if not collision_data or sprite.texture:
		return
	
	pixel_data = get_pixel_data(pos_adjustment, transparency_bias)


func _on_Sprite_texture_changed() -> void:
	if not collision_data:
		yield(self, "collision_update")
	
	pixel_data = get_pixel_data(pos_adjustment, transparency_bias)
	emit_signal("collision_update")



func _on_collision_update() -> void:
	if not is_inside_tree():
		return
	
	pixel_data = get_pixel_data(pos_adjustment, transparency_bias)
	var boundaries : PoolVector2Array = get_boundaries()
	
	if interp.enable and interp.iterations > 0:
		boundaries = interpolate_boundary(boundaries, interp.iterations)
	
	collision_body.polygon = boundaries


func _on_height_updated(new_height : float) -> void:
	VisualServer.canvas_item_add_circle($CollisionPreview.get_canvas_item(), $CollisionPreview.rect_size / 2, 5, Color.white)
	print("E")
