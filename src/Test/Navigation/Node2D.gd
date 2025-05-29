extends Node2D

const MAP_SIZE = Vector2(18, 12)



#func _ready() -> void:
#	generate_nav()
#	$wall.hide()


func _draw() -> void:
	for i in $wall.get_clusters():
		for j in i:
			draw_circle($wall.get_cell_center(j), 5, Color.white)

	for i in $wall.get_clusters_outline():
		for j in i:
			draw_circle(j, 1, Color.black)

		draw_polyline(i, Color.blue)




func generate_nav() -> void:
	var poly : NavigationPolygon = NavigationPolygon.new()
	var poly_instance : NavigationPolygonInstance = NavigationPolygonInstance.new()
	var map_size_world : Vector2 = $wall.map_to_world(MAP_SIZE)
	
	for i in $wall.get_clusters_outline():
#		if i.size() == 4:
#			breakpoint
		poly.add_outline(i)
#		poly.make_polygons_from_outlines()
	poly.make_polygons_from_outlines()
	poly_instance.navpoly = poly
	$Navigation2D.add_child(poly_instance)
	
