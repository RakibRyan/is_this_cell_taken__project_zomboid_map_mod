@tool
extends Window


signal set_new_time(hours, minutes, seconds)

@onready var hours_line_edit = $Control/VBoxContainer/HBoxContainer/InputHours
@onready var minutes_line_edit = $Control/VBoxContainer/HBoxContainer/InputMinutes
@onready var seconds_line_edit = $Control/VBoxContainer/HBoxContainer/InputSeconds
var hours = 0.0
var minutes = 0.0
var seconds = 0.0


func _on_input_hours_text_changed(new_text: String) -> void:
	hours = maxf(float(new_text), 0.0)


func _on_input_minutes_text_changed(new_text: String) -> void:
	minutes = maxf(float(new_text), 0.0)


func _on_input_seconds_text_changed(new_text: String) -> void:
	seconds = maxf(float(new_text), 0.0)


func _on_set_time_button_pressed() -> void:
	emit_signal("set_new_time", hours, minutes, seconds)
