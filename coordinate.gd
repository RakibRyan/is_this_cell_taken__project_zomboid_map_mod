extends RichTextLabel
@onready var world_map = $"../.."
@onready var coordinate = $"."


func cursor_coordinate():
	var mouse_pos = get_global_mouse_position()
	print(mouse_pos)
	var tile_mouse_pos = world_map.local_to_map(mouse_pos)
#	var tile_mouse_pos = parent.local_to_map(mouse_pos)
	print(tile_mouse_pos)
#	var str_test = var_to_str(tile_mouse_pos)
#	print(str_test)
	coordinate.text = "Cell: " + str(tile_mouse_pos.x) + ", " + str(tile_mouse_pos.y)
	pass
#
#
## Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_global_mouse_position())
	cursor_coordinate()
	pass
