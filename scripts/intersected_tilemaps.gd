extends Node2D
var coord_test = Vector2i(27,20)
var t


	
	



func findTilemapsWithCoordinate(coordinate: Vector2) -> Array:
	var tilemaps_with_coordinate = []

	# Iterate through all tilemaps in the scene
	print(get_tree().get_nodes_in_group("TileMap"))
	for node in get_tree().get_nodes_in_group("tilemaps"):
		var tilemap = node

		# Check if the coordinate exists in the current tilemap
		if tilemap.has_cell(coordinate.x, coordinate.y):
			tilemaps_with_coordinate.append(tilemap)

	return tilemaps_with_coordinate

func tiles(address):
	var name = get_node(address)

	pass


func _ready():
	#testing = get_cell_atlas_coords(0, Vector2i(27,20)) 
	
	pass
