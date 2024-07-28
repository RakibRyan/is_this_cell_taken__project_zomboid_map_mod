extends RichTextLabel

# -------- Needs changes------------------
# handels toggling of all maps
func _on_button_toggled(_toggled_on): # Again I have no idea what delta does and why it breaks
	
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true




