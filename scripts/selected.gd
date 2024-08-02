extends Node2D

@onready var selected = $"."
@onready var cursor_coordinate = $"../Camera2D/CanvasLayer/coordinate"
@onready var hover_layer = $"../hover_layer"
@onready var selected_anim = $"./AnimatedSprite2D"


func _unhandled_input(event):
	if event is InputEventMouseMotion:
#		print("mouse movement")   #Debug
#		print(cursor_coordinate.tile_mouse_pos) #Debug
		#clear_layer(0)
		#erase_cell(0, Vector2i(0,0))
	

		
		if cursor_coordinate.tile_mouse_pos != null:
			#set_cell(0, cursor_coordinate.tile_mouse_pos, 1 ,Vector2i(0,0))
			pass
	pass





