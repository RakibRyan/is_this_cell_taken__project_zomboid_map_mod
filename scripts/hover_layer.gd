extends TileMap
@onready var cursor_coordinate = $"../Camera2D/CanvasLayer/coordinate"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	clear_layer(0)
	if cursor_coordinate.tile_mouse_pos != null:
		set_cell(0, cursor_coordinate.tile_mouse_pos, 1 ,Vector2i(0,0))




