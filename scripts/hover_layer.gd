extends TileMap

@onready var cursor_coordinate = $"../Camera2D/CanvasLayer/coordinate"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	clear_layer(0)
	if cursor_coordinate.tile_mouse_pos != null:
		#set_cell(layer:int, coordinate:vector2i,source_id:int ,atlas_coord:vector2i)
		set_cell(0, cursor_coordinate.tile_mouse_pos, 1 ,Vector2i(0,0))
		pass
	pass



