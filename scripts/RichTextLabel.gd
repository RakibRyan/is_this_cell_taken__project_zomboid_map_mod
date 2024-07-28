extends RichTextLabel

# -------- Needs changes------------------
# handels toggling of all maps
func _on_button_toggled(toggled_on):
	
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true




