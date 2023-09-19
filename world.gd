extends TileMap

@onready var world_map = $"."


var Build41map_layer = -1

func cursor_coordinate():
	var mouse_pos = get_global_mouse_position()
	print(mouse_pos)
	var tile_mouse_pos = world_map.local_to_map(mouse_pos)
	print(tile_mouse_pos)
	var str_test = var_to_str(tile_mouse_pos)
	print(str_test)
	$coordinate.text = "Cell: " + str(tile_mouse_pos.x) + ", " + str(tile_mouse_pos.y)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	print_tree()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor_coordinate()
	pass


func _input(event):
	if Input.is_action_just_pressed("click"):
		pass
		#$coordinate.text = str_test
		
		
			#print_tree()
#Camera2D.

