extends Camera2D

var zoom_min = Vector2(.2,.2)
var zoom_max = Vector2(2,2)
var zoom_speed = Vector2(.2,.2)
var current_zoom 
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if zoom > zoom_min:
#					print(zoom) #Debug
					zoom -= zoom_speed
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if zoom < zoom_max:
#					print(zoom) #Debug
					zoom += zoom_speed
	pass


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
