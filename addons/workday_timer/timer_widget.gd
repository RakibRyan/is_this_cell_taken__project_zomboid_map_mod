@tool
extends PanelContainer

var starting_seconds := 18000
var current_countdown_seconds := 0
var timer_paused := true
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $MarginContainer/HBoxContainer/TimerLabel
@onready var pause_button: Button = $MarginContainer/HBoxContainer/PauseButton
@onready var popup_menu: Window = $PopupMenu


func _ready():
	load_time()
	timer_label.label_settings.font_color = Color.WHITE
	var styleBox: StyleBoxFlat = timer_label.get_theme_stylebox("normal")
	styleBox.set("bg_color", Color(0,0,0,0))
	timer_label.add_theme_stylebox_override("normal", styleBox)
	update_timer_label()
	if current_countdown_seconds != 0:
		pause_button.text = "Start"
	else:
		pause_button.text = "Reset"
	
	
# Starts timer.
func start_timer():
	timer.start()
	if current_countdown_seconds != 0:
		pause_button.text = "Pause"
	else:
		pause_button.text = "Reset"


# Pauses timer.
func pause_timer():
	timer.stop()
	if current_countdown_seconds != 0:
		pause_button.text = "Resume"
	else:
		pause_button.text = "Reset"


# Resets timer back to starting_seconds. If play is true, starts the timer immediately.
func reset_timer(play: bool = false):
	timer.stop()
	current_countdown_seconds = starting_seconds
	timer_label.label_settings.font_color = Color.WHITE
	var styleBox: StyleBoxFlat = timer_label.get_theme_stylebox("normal")
	styleBox.set("bg_color", Color(0,0,0,0))
	timer_label.add_theme_stylebox_override("normal", styleBox)
	update_timer_label()
	if play:
		start_timer()
	else:
		pause_button.text = "Start"


# Triggered on timer timeout. Decreases current_countdown_seconds
# and checks if timer has hit 0.
func _on_timer_timeout():
	current_countdown_seconds -= 1
	if current_countdown_seconds <= 0:
		timer.stop()
		timer_label.label_settings.font_color = Color.BLACK
		var styleBox: StyleBoxFlat = timer_label.get_theme_stylebox("normal")
		styleBox.set("bg_color", Color.LIGHT_BLUE)
		timer_label.add_theme_stylebox_override("normal", styleBox)
		pause_button.text = "Reset"
	update_timer_label()

	
# Updates timer display label in editor with current time.
func update_timer_label():
	var remaining_time: int = current_countdown_seconds
	var hours := floor( remaining_time/ 3600)
	remaining_time -= hours * 3600
	var minutes := floor(remaining_time / 60)
	remaining_time -= minutes * 60
	var seconds := remaining_time
	timer_label.text = time_val_to_string(hours) + ":" + time_val_to_string(minutes) + ":" + time_val_to_string(seconds)


# Converts an integer time in seconds to a string. If the value is
# a single digit, adds a zero in front of it for display purposes.
func time_val_to_string(val: int):
	var output := str(val)
	if output.length() == 1:
		output = "0" + output
	return output


# Saves the current starting seconds and the time left on the timer to
# time_save.json. If resume_seconds is -1, the timer will not start at that
# value on next load.
func save_time(resume_seconds = -1):
	var time_save := FileAccess.open("res://addons/workday_timer/time_save.json", FileAccess.WRITE)
	var save_dict := {
		"starting_seconds": starting_seconds,
		"resume_seconds": resume_seconds
	}
	time_save.store_line(JSON.stringify(save_dict))
	

# Loads settings from time_save.json. 
func load_time():
	if not FileAccess.file_exists("res://addons/workday_timer/time_save.json"):
		current_countdown_seconds = starting_seconds
		return
	var time_save := FileAccess.open("res://addons/workday_timer/time_save.json", FileAccess.READ)
	while time_save.get_position() < time_save.get_length():
		var json_string := time_save.get_line()
		var json := JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result := json.parse(json_string)
		if not parse_result == OK:
			print("[Workday Timer] JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object
		var data := json.get_data()
		starting_seconds = data["starting_seconds"]
		var resume_seconds: int = data["resume_seconds"]
		if resume_seconds != -1:
			current_countdown_seconds = resume_seconds
		else:
			current_countdown_seconds = starting_seconds
	
	
# Triggered when the pause putton is released. Behaviour depends on current state 
# of the timer.
func _on_pause_button_button_up():
	if current_countdown_seconds == 0:
		timer_paused = true
		reset_timer()
	elif timer_paused:
		timer_paused = false
		start_timer()
	else:
		timer_paused = true
		pause_timer()


# Triggered when the settings button is released. Brings up settings window.
func _on_settings_button_button_up():
	var remaining_time := starting_seconds
	var hours := floor( remaining_time/ 3600)
	remaining_time -= hours * 3600
	var minutes := floor(remaining_time / 60)
	remaining_time -= minutes * 60
	var seconds := remaining_time
	var hours_edit: SpinBox = popup_menu.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/HoursEdit")
	var minutes_edit: SpinBox = popup_menu.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/MinutesEdit")
	var seconds_edit: SpinBox = popup_menu.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/SecondsEdit")
	hours_edit.value = hours
	minutes_edit.value = minutes
	seconds_edit.value = seconds
	popup_menu.show()


# Triggered when settings window's close button is pressed. Closes settings window.
func _on_popup_menu_close_requested():
	popup_menu.hide()


# Triggered when the reset button is pressed in the settings window. Resets timer to
# value inputted.
func _on_set_button_button_up():
	var hours_edit: SpinBox = popup_menu.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/HoursEdit")
	var minutes_edit: SpinBox = popup_menu.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/MinutesEdit")
	var seconds_edit: SpinBox = popup_menu.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/SecondsEdit")
	var new_seconds := (hours_edit.value * 3600) + (minutes_edit.value * 60) + seconds_edit.value
	starting_seconds = new_seconds
	save_time()
	reset_timer(!timer_paused)


# Triggered when tree exited. Saves current settings and timer value. This
# ensures that the timer will start at the time it had left if the editor
# is closed.
func _on_tree_exited():
	save_time(current_countdown_seconds)
