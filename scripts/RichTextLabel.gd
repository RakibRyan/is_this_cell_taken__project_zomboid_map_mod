extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_toggled(toggled_on):
	
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true
		pass
	pass # Replace with function body.



