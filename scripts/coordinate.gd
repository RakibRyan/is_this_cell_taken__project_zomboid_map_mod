extends RichTextLabel

@export var tile_mouse_pos:Vector2i

@onready var world_map = $"../../.."
@onready var camera2d = $"../"


# gives you the cursor coordinates
func cursor_coordinate():  # print(camera2d.scale) 
	var mouse_pos = get_global_mouse_position() # print(mouse_pos)
	tile_mouse_pos = world_map.local_to_map(world_map.get_local_mouse_position()) # print(tile_mouse_pos) 
	self.text = "Cell: " + str(tile_mouse_pos) 
	return tile_mouse_pos

# ----------------This might need changes-----------------
# Called the first time node loads  
func _ready():
	var data = world_map.get_cell_tile_data(0,Vector2(27,37))


# called every frame to draw cursor
func _process(delta):  #delta do it need it?
	cursor_coordinate()

