@tool
extends Label


signal right_clicked(screen_position: Vector2)


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	var mouse_event := event as InputEventMouseButton
	
	if mouse_event.button_index != MOUSE_BUTTON_RIGHT:
		return
	elif not mouse_event.pressed:
		return
	
	get_viewport().set_input_as_handled()
	right_clicked.emit(get_screen_position() + mouse_event.position)
