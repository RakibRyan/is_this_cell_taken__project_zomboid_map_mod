extends Node2D
@export var modded_tilemaps: Array
var total_no_of_maps
@export var map_list:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready") #Debug
	modded_tilemaps = find_children("*", "TileMap")
	#print(modded_tilemaps)
	total_no_of_maps = modded_tilemaps.size()
	print("Total number of maps: ", total_no_of_maps)
	for tile in modded_tilemaps:
		var temp = str(tile)
		temp = temp.get_slice(":", 0)
		map_list.append(temp)
	print(map_list)
 # Append text with BBCode formatting
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_toggle_map_overlays_toggled(toggled_on):
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true
		pass
	pass # Replace with function body.
