extends TileMap

@export var world_map : TileMap
@export var extracted_names:Array = []

@onready var cursor_coordinate = $"Camera2D/CanvasLayer/coordinate"

var Build41map_layer = -1
var hover_overlay = 1
var tilemaps_with_tiles_in_coord:Array = [] 
var tile_map_names_with_tiles_in_coord:Array = []
var all_tile_maps:Array 


# Compare everymap for occupancy in the cell & Iterate through all tilemaps in the scene
func findTilemapsWithCoordinate() -> Array:
	for tilemap in all_tile_maps:
		if tilemap.get_cell_atlas_coords(0, cursor_coordinate.tile_mouse_pos) != Vector2i(-1,-1): #get_cell_atlas_coords(layer, tile_coord)
			#if tilemap.visible == false:
			tilemaps_with_tiles_in_coord.append(tilemap)
			
	for tile in tilemaps_with_tiles_in_coord:
		var temp = str(tile)
		temp = temp.get_slice(":", 0)
		extracted_names.append(temp)
	extracted_names.remove_at(0)
	
	#if extracted_names.size() == 0:
		#print("No Maps here")
	#else:
		#print(extracted_names)
	return extracted_names
	

# Called when the node enters the scene tree for the first time.
func _ready():
	all_tile_maps = find_children("*", "TileMap") # print(all_tile_maps)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	extracted_names.clear()
	tilemaps_with_tiles_in_coord.clear()
	findTilemapsWithCoordinate()


