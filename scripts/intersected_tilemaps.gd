extends Node2D
var coord_test = Vector2i(27,20)

func findTilemapsWithCoordinate(coordinate: Vector2) -> Array:
	var tilemaps_with_coordinate = []

	# Iterate through all tilemaps in the scene
	print(get_tree().get_nodes_in_group("TileMap"))
	for node in get_tree().get_nodes_in_group("tilemaps"):
		var tilemap = node
		if tilemap.has_cell(coordinate.x, coordinate.y):  # Check if the coordinate exists in the current tilemap
			tilemaps_with_coordinate.append(tilemap)
	return tilemaps_with_coordinate


func _ready():
	#testing = get_cell_atlas_coords(0, Vector2i(27,20)) 
	
	pass
