extends TileMap

@onready var world_map = $"."



var Build41map_layer = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		print(mouse_pos)
		var tile_mouse_pos = world_map.local_to_map(mouse_pos)
		print(tile_mouse_pos)
		#print_tree()
