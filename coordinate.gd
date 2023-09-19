extends RichTextLabel

@onready var world_map = $"../../.."
@onready var coordinate = $"."
@onready var camera2d = $"../"

func cursor_coordinate():
	print(camera2d.scale)
	var mouse_pos = get_global_mouse_position()
#	print(mouse_pos) #Debug
	var tile_mouse_pos = world_map.local_to_map(world_map.get_local_mouse_position())  #world_map.local_to_map(mouse_pos )
#	print(tile_mouse_pos) #Debug
	coordinate.text = "Cell: " + str(tile_mouse_pos.x) + ", " + str(tile_mouse_pos.y)
	pass


## Called when the node enters the scene tree for the first time.
func _ready():
	pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(get_global_mouse_position()) #Debug
	cursor_coordinate()
	pass
