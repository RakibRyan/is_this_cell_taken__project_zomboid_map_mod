extends RichTextLabel

@export var tile_mouse_pos:Vector2i

@onready var world_map = $"../../.."
@onready var camera2d = $"../"


# gives you the cursor coordinates
func cursor_coordinate():  # print(camera2d.scale) 
	tile_mouse_pos = world_map.local_to_map(world_map.get_local_mouse_position()) # print(tile_mouse_pos) 
	self.text = "Cell: " + str(tile_mouse_pos) 
	return tile_mouse_pos

#-----------This needs to change----------
# called every frame to draw cursor
func _process(_delta):  #delta do it need it?
	cursor_coordinate()

