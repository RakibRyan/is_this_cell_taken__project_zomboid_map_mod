extends TileMap

var testing
@export var world_map : TileMap





var Build41map_layer = -1
var hover_overlay = 1
# Called when the node enters the scene tree for the first time.







func _ready():
	print("ready") #Debug
	print_tree()
	#testing = get_cell_atlas_coords(0, Vector2i(27,20)) 
	#print(testing)
	var hello = find_children("*", "TileMap")
	print("test------------------------------")
	print(hello)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
 #cursor_coordinate()

	pass


