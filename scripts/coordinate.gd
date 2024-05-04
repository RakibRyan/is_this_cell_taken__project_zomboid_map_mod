extends RichTextLabel

var tile_mouse_pos

@onready var world_map = $"../../.."
@onready var coordinate = $"."
@onready var camera2d = $"../"



func cursor_coordinate():
#	print(camera2d.scale) #Debug
	var mouse_pos = get_global_mouse_position()
#	print(mouse_pos) #Debug
	tile_mouse_pos = world_map.local_to_map(world_map.get_local_mouse_position())  #world_map.local_to_map(mouse_pos )
#	print(tile_mouse_pos) #Debug
	coordinate.text = "Cell: " + str(tile_mouse_pos.x) + ", " + str(tile_mouse_pos.y) 
	pass

# working
func hover_overlay(position: Vector2i):
	
	pass



func _ready():

	var data = world_map.get_cell_tile_data(0,Vector2(27,37))
#	print(data)
	pass
func _process(delta):
#	print(get_global_mouse_position()) #Debug
	cursor_coordinate()
	pass
