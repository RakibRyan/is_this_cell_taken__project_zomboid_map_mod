extends Camera2D

var zoom_min = Vector2(.1,.1)
var zoom_max = Vector2(2,2)
var zoom_speed = Vector2(.1,.1)
var current_zoom 
var  cursor_in_world = true


# Button Input Handeled
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if cursor_in_world == true:
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					if zoom > zoom_min:
	#					print(zoom) #Debug
						zoom -= zoom_speed
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					if zoom < zoom_max:
	#					print(zoom) #Debug
						zoom += zoom_speed


# Input Unhandeled
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			position -= event.relative / zoom
	
	
	#if event is InputEventMouseMotion:
		##print("Mouse movement")  #Debug
		#pass






# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_rich_text_label_mouse_entered():
	#print("ui")
	cursor_in_world = false
	pass # Replace with function body.


func _on_rich_text_label_mouse_exited():
	#print("world")
	cursor_in_world = true
	pass # Replace with function body.
