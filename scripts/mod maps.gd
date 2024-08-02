extends Node2D
@export var modded_tilemaps: Array
@export var map_list:Array

var total_no_of_maps


# find all tile maps and slices them
func _ready():
	modded_tilemaps = find_children("*", "TileMap") #print(modded_tilemaps)
	total_no_of_maps = modded_tilemaps.size()
	print("Total number of maps: ", total_no_of_maps)
	for tile in modded_tilemaps:
		var temp = str(tile)
		temp = temp.get_slice(":", 0)
		map_list.append(temp)
	#print_tree()


# Toggles button
#  ------------------ But I have no idea why removing it breaks I need to read docs again and change this-------
func _on_toggle_map_overlays_toggled(_toggled_on):
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true
		pass
	pass


