extends Node2D

@onready var selected = $"."
@onready var cursor_coordinate = $"../Camera2D/CanvasLayer/coordinate"
@onready var hover_layer = $"../hover_layer"
@onready var selected_anim = $"./AnimatedSprite2D"


func _unhandled_input(event):
	if event is InputEventMouseMotion:
#		print("mouse movement")   #Debug
#		print(cursor_coordinate.tile_mouse_pos) #Debug
		clear_layer(0)
		if cursor_coordinate.tile_mouse_pos != null:
			set_cell(0, cursor_coordinate.tile_mouse_pos, 1 ,Vector2i(0,0))
		pass
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
#	hover_layer.clear_layer(5)
#	hover_layer.clear_layer(4)
#	hover_layer.clear_layer(6)
#	clear()
#	clear_layer(5)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass






