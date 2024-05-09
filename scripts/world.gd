extends TileMap


@export var world_map : TileMap
@onready var cursor_coordinate = $"Camera2D/CanvasLayer/coordinate"




var Build41map_layer = -1
var hover_overlay = 1
# Called when the node enters the scene tree for the first time.

var tilemaps_with_tiles_in_coord:Array = [] 
var extracted_names:Array = []
var tile_map_names_with_tiles_in_coord:Array = []
var tiles_in_cell: Vector2i 


var all_tile_maps:Array 


# takes an array of tilemaps and returns names in an array
func extract_tilemap_names(tilemap_names: Array) -> Array:
	print("####", tilemap_names)
	for name in tilemap_names:
		extracted_names.append(name.get_slice(":", 0))
	return extracted_names
#Here's how you can use this function:

# Compare everymap for occupancy in the cell & Iterate through all tilemaps in the scene
func findTilemapsWithCoordinate() -> Array:
	for tilemap in all_tile_maps:
		if tilemap.get_cell_atlas_coords(0, cursor_coordinate.tile_mouse_pos) != Vector2i(-1,-1): #get_cell_atlas_coords(layer, tile_coord)
			tilemaps_with_tiles_in_coord.append(tilemap)
	
	if tilemaps_with_tiles_in_coord.size() == 0:
		print("No Maps here")
	else:
		print(tilemaps_with_tiles_in_coord)
	return tilemaps_with_tiles_in_coord



func _ready():
	print("ready") #Debug
	print("get all tilemaps")
	all_tile_maps = find_children("*", "TileMap") #print(all_tile_maps)
	print(all_tile_maps)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tilemaps_with_tiles_in_coord.clear()
	findTilemapsWithCoordinate()
	pass


