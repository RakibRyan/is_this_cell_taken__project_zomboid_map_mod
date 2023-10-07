@tool
extends Control


var session_time = 0.0
var total_time = 0.0
const PATH_TO_SAVE_FILE = "user://time_in_project.save"
@onready var total_time_label : Label = get_node("VBoxContainer/TimeInProject")
@onready var session_time_label : Label = get_node("VBoxContainer/TimeThisSession")
@onready var settings_window : Window = get_node("SettingsWindow")


func _enter_tree() -> void:
	read_file()


func _exit_tree() -> void:
	save_file()


func _process(delta: float) -> void:
	session_time += delta
	total_time += delta
	
	set_time()


func set_time() -> void:
	total_time_label.text = "Time in project: " + get_time_string_from_unix(total_time)
	session_time_label.text = "Time this session: " + get_time_string_from_unix(session_time)


func get_time_string_from_unix(unix_time):
	var time_string = ""
	var unix_time_int = int(unix_time)
	
	var hours = floor(unix_time_int / 3600)
	if hours < 10:
		time_string += "0"
	time_string += str(hours) + ":"
	unix_time_int -= hours * 3600
	
	var minutes = floor(unix_time_int / 60)
	if minutes < 10:
		time_string += "0"
	time_string += str(minutes) + ":"
	unix_time_int -= minutes * 60
	
	var seconds = unix_time_int
	if seconds < 10:
		time_string += "0"
	time_string += str(seconds)
	
	return time_string


func read_file() -> void:
	if not FileAccess.file_exists(PATH_TO_SAVE_FILE):
		return
	
	var save = FileAccess.open(PATH_TO_SAVE_FILE, FileAccess.READ)
	
	var json_string := ""
	while save.get_position() < save.get_length():
		json_string += save.get_line()
	
	var parsed_result = JSON.parse_string(json_string)
	
	total_time = float(parsed_result['time'])
	


func save_file() -> void:
	var save = FileAccess.open(PATH_TO_SAVE_FILE, FileAccess.WRITE)
	save.store_line(JSON.stringify({'time': roundf(total_time)}, "\t"))


func _on_settings_button_pressed() -> void:
	settings_window.show()


func _on_settings_window_close_requested() -> void:
	settings_window.hide()


func _on_settings_window_set_new_time(hours, minutes, seconds) -> void:
	var unix_time = hours * 3600 + minutes * 60 + seconds
	total_time = unix_time
	print("Set Time in project to: " + get_time_string_from_unix(total_time))
