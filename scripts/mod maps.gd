extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print_tree() #will be moved to new maps section


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_toggle_map_overlays_toggled(toggled_on):
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true


