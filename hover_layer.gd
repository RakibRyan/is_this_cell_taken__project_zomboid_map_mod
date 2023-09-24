extends TileMap
@onready var hover_layer = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
#	hover_layer.clear_layer(5)
#	hover_layer.clear_layer(4)
#	hover_layer.clear_layer(6)
#	clear()
#	clear_layer(5)
	print(hover_layer.get_layers_count ())
	print(hover_layer.get_layer_z_index (5))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
